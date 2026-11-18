using MySql.Data.MySqlClient;

namespace GymRegistrationApp.Services;

public sealed record AttendanceSubmission(string FirstName, string MiddleName, string LastName, string MemberId);

public sealed record AttendanceResult(
    bool Success,
    string Message,
    string MemberId = "",
    string FullName = "",
    DateTime? AttendanceDate = null,
    DateTime? CheckInTime = null);

public static class AttendanceService
{
    private static readonly TimeZoneInfo ManilaTimeZone = ResolveManilaTimeZone();

    public static AttendanceResult Record(AttendanceSubmission submission, string recordedBy)
    {
        var first = submission.FirstName.Trim();
        var middle = submission.MiddleName.Trim();
        var last = submission.LastName.Trim();
        var memberId = submission.MemberId.Trim().ToUpperInvariant();

        if (first.Length == 0 || last.Length == 0 || memberId.Length == 0)
            return new(false, "First name, last name, and member ID are required.");
        if (!System.Text.RegularExpressions.Regex.IsMatch(memberId, "^GM[0-9]{6}$"))
            return new(false, "Member ID must use the GM###### format.");
        if (!DatabaseConnection.TestConnection())
            return new(false, "The attendance service is temporarily unavailable.");

        var now = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, ManilaTimeZone);
        var date = now.Date;
        using var connection = DatabaseConnection.GetConnection();
        connection.Open();
        using var transaction = connection.BeginTransaction();

        try
        {
            using var memberCommand = new MySqlCommand(@"
SELECT id, first_name, middle_name, last_name, full_name, expiry_date, status
FROM members
WHERE id=@id AND is_deleted=0
FOR UPDATE", connection, transaction);
            memberCommand.Parameters.AddWithValue("@id", memberId);
            using var reader = memberCommand.ExecuteReader();
            if (!reader.Read()) return new(false, "Member ID or name could not be verified.");

            var dbFirst = Convert.ToString(reader["first_name"]) ?? "";
            var dbMiddle = Convert.ToString(reader["middle_name"]) ?? "";
            var dbLast = Convert.ToString(reader["last_name"]) ?? "";
            var fullName = Convert.ToString(reader["full_name"]) ?? $"{dbFirst} {dbLast}";
            var expiry = Convert.ToDateTime(reader["expiry_date"]).Date;
            var status = Convert.ToString(reader["status"]) ?? "";
            var matches = string.Equals(first, dbFirst, StringComparison.OrdinalIgnoreCase)
                && string.Equals(middle, dbMiddle, StringComparison.OrdinalIgnoreCase)
                && string.Equals(last, dbLast, StringComparison.OrdinalIgnoreCase);
            if (!matches) return new(false, "Member information does not match the registered member.");
            if (!string.Equals(status, "Active", StringComparison.OrdinalIgnoreCase) || expiry < date)
                return new(false, "The membership is inactive or expired.");
            reader.Close();

            using var duplicateCommand = new MySqlCommand(@"
SELECT COUNT(*) FROM attendance_records
WHERE member_id=@id AND attendance_date=@date AND is_deleted=0", connection, transaction);
            duplicateCommand.Parameters.AddWithValue("@id", memberId);
            duplicateCommand.Parameters.AddWithValue("@date", date);
            if (Convert.ToInt32(duplicateCommand.ExecuteScalar()) > 0)
                return new(false, "Attendance has already been recorded today.", memberId, fullName, date, now);

            var attendanceId = $"ATT-{Guid.NewGuid():N}";
            using var attendanceCommand = new MySqlCommand(@"
INSERT INTO attendance_records
(id, member_id, member_name, attendance_date, check_in_time, recorded_by)
VALUES (@attendanceId, @memberId, @memberName, @date, @time, @recordedBy)", connection, transaction);
            attendanceCommand.Parameters.AddWithValue("@attendanceId", attendanceId);
            attendanceCommand.Parameters.AddWithValue("@memberId", memberId);
            attendanceCommand.Parameters.AddWithValue("@memberName", fullName);
            attendanceCommand.Parameters.AddWithValue("@date", date);
            attendanceCommand.Parameters.AddWithValue("@time", now);
            attendanceCommand.Parameters.AddWithValue("@recordedBy", recordedBy);
            attendanceCommand.ExecuteNonQuery();

            using var visitCommand = new MySqlCommand(@"
INSERT INTO daily_gym_visits
(id, first_name, middle_name, last_name, member_id, is_gym_member, visit_date, fee, payment_method, payment_reference, registered_by)
VALUES (@visitId, @first, @middle, @last, @memberId, 1, @date, 0.00, 'Included', '', @recordedBy)", connection, transaction);
            visitCommand.Parameters.AddWithValue("@visitId", $"DG-{Guid.NewGuid():N}");
            visitCommand.Parameters.AddWithValue("@first", dbFirst);
            visitCommand.Parameters.AddWithValue("@middle", dbMiddle);
            visitCommand.Parameters.AddWithValue("@last", dbLast);
            visitCommand.Parameters.AddWithValue("@memberId", memberId);
            visitCommand.Parameters.AddWithValue("@date", date);
            visitCommand.Parameters.AddWithValue("@recordedBy", recordedBy);
            visitCommand.ExecuteNonQuery();

            transaction.Commit();
            return new(true, "Attendance recorded successfully.", memberId, fullName, date, now);
        }
        catch (MySqlException ex) when (ex.Number == 1062)
        {
            transaction.Rollback();
            return new(false, "Attendance has already been recorded today.", memberId);
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public static DateTime ManilaNow() => TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, ManilaTimeZone);

    private static TimeZoneInfo ResolveManilaTimeZone()
    {
        try { return TimeZoneInfo.FindSystemTimeZoneById("Asia/Manila"); }
        catch (TimeZoneNotFoundException) { return TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"); }
    }
}
