using GymRegistrationApp.Models;
using GymRegistrationApp.Services;

namespace GymRegistrationApp.Forms;

public sealed class AttendanceForm : Form
{
    private readonly string _username;
    private readonly DateTimePicker _datePicker = new() { Format = DateTimePickerFormat.Long, Width = 150 };
    private readonly TextBox _searchBox = new() { Width = 270, PlaceholderText = "Search member name or ID" };
    private readonly Label _selectedSummary = new() { AutoSize = true };
    private readonly Label _monthSummary = new() { AutoSize = true };
    private readonly Label _selectedMember = new() { AutoSize = true, Text = "No member selected" };
    private readonly DataGridView _membersGrid = new() { Dock = DockStyle.Fill, AutoGenerateColumns = false, AllowUserToAddRows = false, ReadOnly = true, SelectionMode = DataGridViewSelectionMode.FullRowSelect, MultiSelect = false };
    private readonly DataGridView _attendanceGrid = new() { Dock = DockStyle.Fill, AutoGenerateColumns = false, AllowUserToAddRows = false, ReadOnly = true, SelectionMode = DataGridViewSelectionMode.FullRowSelect, MultiSelect = false };
    private Member? SelectedMember => (_membersGrid.CurrentRow?.DataBoundItem as MemberSearchResult)?.Member;

    public AttendanceForm(string username, DateTime? selectedDate = null)
    {
        _username = username;
        _datePicker.Value = selectedDate?.Date ?? DateTime.Today;
        Text = "Member Attendance";
        StartPosition = FormStartPosition.CenterParent;
        MinimumSize = new Size(900, 600);
        Size = new Size(1100, 720);
        BackColor = Color.FromArgb(245, 246, 249);
        BuildLayout();
        _datePicker.ValueChanged += (_, _) => RefreshView();
        _searchBox.TextChanged += (_, _) => RefreshMembers();
        RefreshView();
    }

    private void BuildLayout()
    {
        var root = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(24), RowCount = 6, ColumnCount = 1 };
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 48));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 46));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 64));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 54));
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 48));
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 52));

        var title = new Label { Text = "Member Attendance", Font = new Font("Segoe UI", 22, FontStyle.Bold), ForeColor = Color.FromArgb(29, 36, 52), Dock = DockStyle.Fill };
        root.Controls.Add(title, 0, 0);

        var calendar = new FlowLayoutPanel { Dock = DockStyle.Fill, WrapContents = false };
        var previous = Button("Previous"); previous.Click += (_, _) => _datePicker.Value = _datePicker.Value.Date.AddDays(-1);
        var today = Button("Today"); today.Click += (_, _) => _datePicker.Value = DateTime.Today;
        var next = Button("Next"); next.Click += (_, _) => _datePicker.Value = _datePicker.Value.Date.AddDays(1);
        calendar.Controls.AddRange(new Control[] { previous, _datePicker, today, next });
        root.Controls.Add(calendar, 0, 1);

        var metrics = new FlowLayoutPanel { Dock = DockStyle.Fill, WrapContents = false, BackColor = Color.White, Padding = new Padding(14) };
        metrics.Controls.Add(_selectedSummary); metrics.Controls.Add(new Label { Width = 28 }); metrics.Controls.Add(_monthSummary);
        root.Controls.Add(metrics, 0, 2);

        var searchPanel = new FlowLayoutPanel { Dock = DockStyle.Fill, WrapContents = false };
        searchPanel.Controls.Add(new Label { Text = "Search member", AutoSize = true, Margin = new Padding(0, 8, 8, 0) });
        searchPanel.Controls.Add(_searchBox);
        searchPanel.Controls.Add(_selectedMember);
        var add = Button("Add attendance"); add.Click += (_, _) => AddAttendance();
        searchPanel.Controls.Add(add);
        root.Controls.Add(searchPanel, 0, 3);

        _membersGrid.Columns.Add(new DataGridViewTextBoxColumn { HeaderText = "MEMBER", DataPropertyName = "DisplayName", AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill });
        _membersGrid.Columns.Add(new DataGridViewTextBoxColumn { HeaderText = "MEMBER ID", DataPropertyName = "Id", Width = 150 });
        _membersGrid.Columns.Add(new DataGridViewTextBoxColumn { HeaderText = "PLAN", DataPropertyName = "Plan", Width = 130 });
        _membersGrid.SelectionChanged += (_, _) => UpdateSelectedMember();
        root.Controls.Add(_membersGrid, 0, 4);

        _attendanceGrid.Columns.Add(new DataGridViewTextBoxColumn { HeaderText = "MEMBER", DataPropertyName = "MemberName", AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill });
        _attendanceGrid.Columns.Add(new DataGridViewTextBoxColumn { HeaderText = "MEMBER ID", DataPropertyName = "MemberId", Width = 150 });
        _attendanceGrid.Columns.Add(new DataGridViewTextBoxColumn { HeaderText = "CHECK-IN TIME", DataPropertyName = "CheckInTime", Width = 170, DefaultCellStyle = new DataGridViewCellStyle { Format = "h:mm tt" } });
        _attendanceGrid.Columns.Add(new DataGridViewTextBoxColumn { HeaderText = "RECORDED BY", DataPropertyName = "RecordedBy", Width = 130 });
        root.Controls.Add(_attendanceGrid, 0, 5);
        Controls.Add(root);
    }

    private static Button Button(string text) => new() { Text = text, AutoSize = true, FlatStyle = FlatStyle.Flat, BackColor = Color.FromArgb(255, 132, 35), ForeColor = Color.White, Margin = new Padding(4, 0, 4, 0) };

    private void RefreshView()
    {
        var date = _datePicker.Value.Date;
        var attendance = DataStore.AttendanceRecords.Where(a => a.AttendanceDate.Date == date && !a.IsDeleted).OrderBy(a => a.MemberName).ToList();
        var monthStart = new DateTime(date.Year, date.Month, 1);
        var monthAttendance = DataStore.AttendanceRecords.Count(a => a.AttendanceDate >= monthStart && a.AttendanceDate < monthStart.AddMonths(1) && !a.IsDeleted);
        _selectedSummary.Text = $"{attendance.Count} members attended  •  No payment required";
        _monthSummary.Text = $"This month: {monthAttendance} attendances";
        _attendanceGrid.DataSource = null;
        _attendanceGrid.DataSource = attendance;
        RefreshMembers();
    }

    private void RefreshMembers()
    {
        var date = _datePicker.Value.Date;
        var search = _searchBox.Text.Trim();
        var attendedIds = DataStore.AttendanceRecords
            .Where(a => a.AttendanceDate.Date == date && !a.IsDeleted)
            .Select(a => a.MemberId)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);
        var members = DataStore.Members
            .Where(m => !m.IsDeleted && m.StartDate.Date <= date && m.ExpiryDate.Date >= date && string.Equals(m.Status, "Active", StringComparison.OrdinalIgnoreCase))
            .Where(m => !attendedIds.Contains(m.Id))
            .Where(m => string.IsNullOrWhiteSpace(search) || m.Id.Contains(search, StringComparison.OrdinalIgnoreCase) || GetMemberName(m).Contains(search, StringComparison.OrdinalIgnoreCase))
            .OrderBy(m => GetMemberName(m))
            .ToList();
        _membersGrid.DataSource = null;
        _membersGrid.DataSource = members.Select(m => new MemberSearchResult(m)).ToList();
        UpdateSelectedMember();
    }

    private void UpdateSelectedMember()
    {
        _selectedMember.Text = SelectedMember is { } member ? $"Selected: {GetMemberName(member)}" : "No member selected";
    }

    private void AddAttendance()
    {
        var member = SelectedMember;
        if (member is null) { MessageBox.Show("Select a member first.", "Attendance", MessageBoxButtons.OK, MessageBoxIcon.Information); return; }
        var date = _datePicker.Value.Date;
        if (DataStore.AttendanceRecords.Any(a => !a.IsDeleted && a.MemberId == member.Id && a.AttendanceDate.Date == date))
        {
            MessageBox.Show("This member is already marked present for the selected date.", "Attendance", MessageBoxButtons.OK, MessageBoxIcon.Information);
            RefreshView();
            return;
        }

        if (DatabaseConnection.TestConnection())
        {
            var result = AttendanceService.Record(
                new AttendanceSubmission(member.FirstName, member.MiddleName, member.LastName, member.Id),
                _username);
            if (!result.Success)
            {
                MessageBox.Show(result.Message, "Attendance", MessageBoxButtons.OK, MessageBoxIcon.Information);
                RefreshView();
                return;
            }

            DataStore.Reload();
            RefreshView();
            return;
        }

        DataStore.AttendanceRecords.Add(new AttendanceRecord
        {
            Id = DataStore.NewAttendanceId(),
            MemberId = member.Id,
            MemberName = GetMemberName(member),
            AttendanceDate = date,
            CheckInTime = DateTime.Now,
            RecordedBy = _username
        });
        DataStore.SaveAttendanceRecords();
        RefreshView();
    }

    private static string GetMemberName(Member member) => !string.IsNullOrWhiteSpace(member.FullName)
        ? member.FullName
        : string.Join(" ", new[] { member.FirstName, member.MiddleName, member.LastName }.Where(part => !string.IsNullOrWhiteSpace(part)));

    private sealed class MemberSearchResult
    {
        public Member Member { get; }
        public string Id { get; }
        public string DisplayName { get; }
        public string Plan { get; }

        public MemberSearchResult(Member member)
        {
            Member = member;
            Id = member.Id;
            DisplayName = GetMemberName(member);
            Plan = member.Plan;
        }
    }
}
