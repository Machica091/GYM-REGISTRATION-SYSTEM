#nullable enable

using GymRegistrationApp.Models;
using GymRegistrationApp.Services;
using System.Security.Cryptography;

namespace GymRegistrationApp.Forms;

public partial class CreateStaffDialog : Form
{
    private Staff? _staff;
    private readonly Staff? _editingStaff;
    private Panel? _contentPanel;
    private readonly Dictionary<string, CheckBox> _permissionChecks = new();

    public CreateStaffDialog(Staff? staff = null)
    {
        _editingStaff = staff;
        InitializeUI();
    }

    public Staff? GetStaff() => _staff;

    private void InitializeUI()
    {
        this.Text = _editingStaff is null ? "Create new account" : "Edit staff account";
        this.Size = new Size(720, 820);
        this.StartPosition = FormStartPosition.CenterParent;
        this.FormBorderStyle = FormBorderStyle.FixedDialog;
        this.MinimizeBox = false;
        this.MaximizeBox = false;
        this.BackColor = Color.White;

        _contentPanel = new Panel
        {
            Dock = DockStyle.Fill,
            AutoScroll = true,
            Padding = new Padding(24)
        };

        int y = 20;

        var infoBox = new Panel
        {
            Location = new Point(0, y),
            Size = new Size(650, 72),
            BackColor = Color.FromArgb(255, 247, 237),
            BorderStyle = BorderStyle.FixedSingle
        };
        var infoLabel = new Label
        {
            Text = "Staff account access: New users can manage members, renewals, payments, and balances. Income reports and user management remain owner-only.",
            Font = new Font("Segoe UI", 9.5f),
            ForeColor = Color.FromArgb(191, 76, 20),
            AutoSize = false,
            Dock = DockStyle.Fill,
            Padding = new Padding(12)
        };
        infoBox.Controls.Add(infoLabel);
        _contentPanel.Controls.Add(infoBox);
        y += 90;

        var lblFirstName = new Label { Text = "First name", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(0, y), AutoSize = true };
        var txtFirstName = new TextBox { Name = "txtFirstName", PlaceholderText = "e.g. Maria", Location = new Point(0, y + 25), Size = new Size(200, 32), Padding = new Padding(8, 5, 8, 5) };
        _contentPanel.Controls.Add(lblFirstName);
        _contentPanel.Controls.Add(txtFirstName);

        var lblMiddleName = new Label { Text = "Middle name", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(225, y), AutoSize = true };
        var txtMiddleName = new TextBox { Name = "txtMiddleName", PlaceholderText = "e.g. Dela Cruz", Location = new Point(225, y + 25), Size = new Size(200, 32), Padding = new Padding(8, 5, 8, 5) };
        _contentPanel.Controls.Add(lblMiddleName);
        _contentPanel.Controls.Add(txtMiddleName);

        var lblLastName = new Label { Text = "Last name", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(450, y), AutoSize = true };
        var txtLastName = new TextBox { Name = "txtLastName", PlaceholderText = "e.g. Santos", Location = new Point(450, y + 25), Size = new Size(200, 32), Padding = new Padding(8, 5, 8, 5) };
        _contentPanel.Controls.Add(lblLastName);
        _contentPanel.Controls.Add(txtLastName);
        y += 80;

        var lblEmail = new Label { Text = "Username", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(0, y), AutoSize = true };
        var txtEmail = new TextBox { Name = "txtEmail", PlaceholderText = "staff@universalgym.ph", Location = new Point(0, y + 25), Size = new Size(310, 32), Padding = new Padding(8, 5, 8, 5) };
        _contentPanel.Controls.Add(lblEmail);
        _contentPanel.Controls.Add(txtEmail);

        var lblPhone = new Label { Text = "Phone number", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(340, y), AutoSize = true };
        var txtPhone = new TextBox { Name = "txtPhone", PlaceholderText = "09XXXXXXXXX", MaxLength = 11, Location = new Point(340, y + 25), Size = new Size(310, 32), Padding = new Padding(8, 5, 8, 5) };
        txtPhone.KeyPress += (_, args) =>
        {
            if (!char.IsControl(args.KeyChar) && !char.IsDigit(args.KeyChar))
                args.Handled = true;
        };
        _contentPanel.Controls.Add(lblPhone);
        _contentPanel.Controls.Add(txtPhone);
        y += 80;

        var lblBirthday = new Label { Text = "Birthday", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(0, y), AutoSize = true };
        var txtBirthday = new DateTimePicker
        {
            Name = "txtBirthday",
            Format = DateTimePickerFormat.Custom,
            CustomFormat = "MM/dd/yyyy",
            MaxDate = DateTime.Today,
            Value = _editingStaff?.Birthday > DateTime.Today ? DateTime.Today : (_editingStaff?.Birthday ?? DateTime.Today),
            Location = new Point(0, y + 25),
            Size = new Size(310, 32)
        };
        _contentPanel.Controls.Add(lblBirthday);
        _contentPanel.Controls.Add(txtBirthday);

        var lblAccountType = new Label { Text = "Position", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(340, y), AutoSize = true };
        var cmbAccountType = new ComboBox
        {
            Name = "cmbAccountType",
            DropDownStyle = ComboBoxStyle.DropDownList,
            Location = new Point(340, y + 25),
            Size = new Size(310, 32)
        };
        cmbAccountType.Items.AddRange(DatabaseConnection.GetStaffPositions().Cast<object>().ToArray());
        cmbAccountType.SelectedItem = _editingStaff?.Position ?? "Front Desk Staff";
        if (cmbAccountType.SelectedIndex < 0 && cmbAccountType.Items.Count > 0) cmbAccountType.SelectedIndex = 0;
        _contentPanel.Controls.Add(lblAccountType);
        _contentPanel.Controls.Add(cmbAccountType);
        y += 80;

        var lblAddress = new Label { Text = "Home address", Font = new Font("Segoe UI", 10, FontStyle.Bold), Location = new Point(0, y), AutoSize = true };
        var txtAddress = new TextBox { Name = "txtAddress", PlaceholderText = "Street, City, Province", Location = new Point(0, y + 25), Size = new Size(650, 32), Padding = new Padding(8, 5, 8, 5) };
        _contentPanel.Controls.Add(lblAddress);
        _contentPanel.Controls.Add(txtAddress);
        y += 80;

        var permissionsBox = new GroupBox
        {
            Text = "Account permissions",
            Font = new Font("Segoe UI", 10, FontStyle.Bold),
            Location = new Point(0, y),
            Size = new Size(650, 220),
            ForeColor = Color.FromArgb(29, 36, 52)
        };
        var permissions = new (string Key, string Text)[]
        {
            ("CanViewMembers", "View members"),
            ("CanAddMembers", "Add members"),
            ("CanEditMembers", "Edit members"),
            ("CanDeleteMembers", "Delete members"),
            ("CanManagePayments", "Manage payments"),
            ("CanManageDailyGym", "Manage Daily Gym"),
            ("CanViewReports", "View reports"),
            ("CanManageExpenses", "Manage expenses"),
            ("CanManageStaff", "Manage staff accounts"),
            ("CanViewDeletedRecords", "View Archive"),
            ("CanViewOverviewMemberships", "Overview: memberships"),
            ("CanViewOverviewDailyGym", "Overview: Daily Gym"),
            ("CanViewOverviewPayments", "Overview: payment records"),
            ("CanViewOverviewRevenue", "Overview: revenue and trend")
        };
        for (var index = 0; index < permissions.Length; index++)
        {
            var permission = permissions[index];
            var checkBox = new CheckBox
            {
                Name = permission.Key,
                Text = permission.Text,
                Checked = GetPermissionValue(_editingStaff?.Permissions, permission.Key),
                AutoSize = true,
                Location = new Point(15 + (index % 2) * 315, 28 + (index / 2) * 27),
                Font = new Font("Segoe UI", 9),
                ForeColor = Color.FromArgb(70, 80, 90)
            };
            _permissionChecks[permission.Key] = checkBox;
            permissionsBox.Controls.Add(checkBox);
        }
        _contentPanel.Controls.Add(permissionsBox);
        y += 240;

        y += 20;

        var btnCancel = new Button
        {
            Text = "Cancel",
            Location = new Point(390, y),
            Size = new Size(120, 40),
            FlatStyle = FlatStyle.Flat,
            BackColor = Color.White,
            ForeColor = Color.FromArgb(80, 100, 130),
            Font = new Font("Segoe UI", 10, FontStyle.Bold),
            Name = "btnCancel"
        };
        btnCancel.FlatAppearance.BorderSize = 1;
        btnCancel.FlatAppearance.BorderColor = Color.LightGray;
        btnCancel.Click += (_, _) => DialogResult = DialogResult.Cancel;
        _contentPanel.Controls.Add(btnCancel);

        var btnCreate = new Button
        {
            Text = _editingStaff is null ? "Create account" : "Save changes",
            Location = new Point(510, y),
            Size = new Size(140, 40),
            FlatStyle = FlatStyle.Flat,
            BackColor = Color.FromArgb(255, 132, 35),
            ForeColor = Color.White,
            Font = new Font("Segoe UI", 10, FontStyle.Bold),
            Name = "btnCreate"
        };
        btnCreate.FlatAppearance.BorderSize = 0;
        btnCreate.Click += BtnCreate_Click;
        _contentPanel.Controls.Add(btnCreate);

        this.Controls.Add(_contentPanel);

        SetTextBoxValue("txtFirstName", _editingStaff?.FirstName);
        SetTextBoxValue("txtMiddleName", _editingStaff?.MiddleName);
        SetTextBoxValue("txtLastName", _editingStaff?.LastName);
        SetTextBoxValue("txtEmail", _editingStaff?.Email);
        SetTextBoxValue("txtPhone", _editingStaff?.PhoneNumber);
        SetTextBoxValue("txtAddress", _editingStaff?.HomeAddress);
    }

    private void BtnCreate_Click(object? sender, EventArgs e)
    {
        var firstName = GetTextBoxValue("txtFirstName");
        var middleName = GetTextBoxValue("txtMiddleName");
        var lastName = GetTextBoxValue("txtLastName");
        var email = GetTextBoxValue("txtEmail");
        var phone = GetTextBoxValue("txtPhone");
        var birthdayPicker = FindControlRecursively<DateTimePicker>(this, "txtBirthday");
        var birthday = birthdayPicker?.Value.Date ?? DateTime.MinValue;
        var address = GetTextBoxValue("txtAddress");
        var password = _editingStaff is null ? GenerateTemporaryPassword() : _editingStaff.Password;

        if (string.IsNullOrWhiteSpace(firstName))
        {
            MessageBox.Show("Please enter the first name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        if (string.IsNullOrWhiteSpace(lastName))
        {
            MessageBox.Show("Please enter the last name.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        if (string.IsNullOrWhiteSpace(email))
        {
            MessageBox.Show("Please enter a username using the @universalgym.ph domain.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        var emailParts = email.Split('@');
        if (emailParts.Length != 2 || string.IsNullOrWhiteSpace(emailParts[0]) ||
            !emailParts[1].Equals("universalgym.ph", StringComparison.OrdinalIgnoreCase) ||
            email.Any(char.IsWhiteSpace))
        {
            MessageBox.Show("Username must end with @universalgym.ph.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        if (phone.Length != 11 || phone.Any(c => !char.IsDigit(c)))
        {
            MessageBox.Show("Phone number must contain exactly 11 digits.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        var birthDate = birthday;

        if (string.IsNullOrWhiteSpace(address))
        {
            MessageBox.Show("Please enter a home address.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        var username = emailParts[0].Trim();
        var fullName = string.Join(" ", new[] { firstName, middleName, lastName }.Where(part => !string.IsNullOrWhiteSpace(part)));

        _staff = new Staff
        {
            Id = _editingStaff?.Id ?? 0,
            FirstName = firstName,
            MiddleName = middleName,
            LastName = lastName,
            FullName = fullName,
            Email = email,
            PhoneNumber = phone,
            Birthday = birthDate,
            Position = GetComboBoxValue("cmbAccountType"),
            HomeAddress = address,
            Username = _editingStaff?.Username ?? username,
            Password = password,
            PasswordHash = _editingStaff?.PasswordHash ?? "",
            JoinedDate = _editingStaff?.JoinedDate ?? DateTime.Today,
            Status = _editingStaff?.Status ?? "Active",
            Permissions = ReadPermissions()
        };

        this.DialogResult = DialogResult.OK;
        this.Close();
    }

    private void SetTextBoxValue(string name, string? value)
    {
        var control = FindControlRecursively<TextBox>(this, name);
        if (control is not null) control.Text = value ?? "";
    }

    private StaffPermissions ReadPermissions()
    {
        var permissions = StaffPermissions.CreateDefault();
        foreach (var check in _permissionChecks)
        {
            var property = typeof(StaffPermissions).GetProperty(check.Key);
            property?.SetValue(permissions, check.Value.Checked);
        }

        return permissions;
    }

    private static bool GetPermissionValue(StaffPermissions? permissions, string propertyName)
    {
        permissions ??= StaffPermissions.CreateDefault();
        return typeof(StaffPermissions).GetProperty(propertyName)?.GetValue(permissions) is bool value && value;
    }

    private static string GenerateTemporaryPassword()
    {
        const string uppercase = "ABCDEFGHJKLMNPQRSTUVWXYZ";
        const string lowercase = "abcdefghijkmnopqrstuvwxyz";
        const string digits = "23456789";
        const string symbols = "!@#$%";
        var password = new char[12];
        password[0] = uppercase[RandomNumberGenerator.GetInt32(uppercase.Length)];
        password[1] = lowercase[RandomNumberGenerator.GetInt32(lowercase.Length)];
        password[2] = digits[RandomNumberGenerator.GetInt32(digits.Length)];
        password[3] = symbols[RandomNumberGenerator.GetInt32(symbols.Length)];
        var all = uppercase + lowercase + digits + symbols;
        for (var i = 4; i < password.Length; i++)
        {
            password[i] = all[RandomNumberGenerator.GetInt32(all.Length)];
        }

        RandomNumberGenerator.Shuffle(password.AsSpan());
        return new string(password);
    }

    private string GetTextBoxValue(string name)
    {
        var control = FindControlRecursively<TextBox>(this, name);
        return control?.Text.Trim() ?? "";
    }

    private string GetComboBoxValue(string name)
    {
        var control = FindControlRecursively<ComboBox>(this, name);
        return control?.Text.Trim() ?? "";
    }

    private static T? FindControlRecursively<T>(Control root, string name) where T : Control
    {
        if (root is T typed && string.Equals(typed.Name, name, StringComparison.Ordinal))
            return typed;

        foreach (Control child in root.Controls)
        {
            var match = FindControlRecursively<T>(child, name);
            if (match is not null)
                return match;
        }

        return null;
    }
}
