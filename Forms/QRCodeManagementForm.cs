using System.Drawing.Printing;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Text.Json;
using QRCoder;

namespace GymRegistrationApp.Forms;

public sealed class QRCodeManagementForm : Form
{
    private string _attendanceUrl = string.Empty;
    private bool _usingConfiguredUrl;
    private readonly TextBox _urlInput = new() { Width = 470, PlaceholderText = "https://your-public-attendance-host/attendance" };
    private readonly PictureBox _preview = new() { Dock = DockStyle.Fill, SizeMode = PictureBoxSizeMode.Zoom, BackColor = Color.White, BorderStyle = BorderStyle.FixedSingle };
    private readonly Label _status = new() { AutoSize = true };
    private readonly PrintDocument _printDocument = new();
    private byte[]? _png;
    private static readonly string SettingsFile = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
        "GymRegistrationApp",
        "attendance-settings.json");

    public QRCodeManagementForm()
    {
        _ = StartAttendanceApi();
        (_attendanceUrl, _usingConfiguredUrl) = ResolveAttendanceUrl();
        Text = "QR Code Management";
        StartPosition = FormStartPosition.CenterParent;
        MinimumSize = new Size(640, 680);
        Size = new Size(760, 760);
        BackColor = Color.FromArgb(245, 246, 249);
        BuildLayout();
        GenerateCode();
        _printDocument.PrintPage += PrintDocument_PrintPage;
    }

    private void BuildLayout()
    {
        var root = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(28), RowCount = 6, ColumnCount = 1 };
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 48));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 112));
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 54));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 54));
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 36));

        root.Controls.Add(new Label { Text = "QR Code Management", Font = new Font("Segoe UI", 22, FontStyle.Bold), ForeColor = Color.FromArgb(29, 36, 52), Dock = DockStyle.Fill }, 0, 0);
        var urlPanel = new FlowLayoutPanel { Dock = DockStyle.Fill, WrapContents = true, BackColor = Color.White, Padding = new Padding(12) };
        urlPanel.Controls.Add(new Label { Text = "Attendance URL:", AutoSize = true, Font = new Font("Segoe UI", 10, FontStyle.Bold), Margin = new Padding(0, 5, 6, 0) });
        _urlInput.Text = _attendanceUrl;
        urlPanel.Controls.Add(_urlInput);
        var saveUrl = new Button { Text = "Save / Update URL", AutoSize = true, FlatStyle = FlatStyle.Flat, BackColor = Color.FromArgb(255, 132, 35), ForeColor = Color.White };
        saveUrl.Click += (_, _) => SaveAttendanceUrl();
        urlPanel.Controls.Add(saveUrl);
        var copyButton = new Button { Text = "Copy Attendance Link", AutoSize = true, FlatStyle = FlatStyle.Flat, BackColor = Color.FromArgb(255, 132, 35), ForeColor = Color.White, Tag = "copy" };
        copyButton.Click += (_, _) => CopyLink();
        urlPanel.Controls.Add(copyButton);
        root.Controls.Add(urlPanel, 0, 1);
        root.Controls.Add(_preview, 0, 2);

        var viewPanel = new FlowLayoutPanel { Dock = DockStyle.Fill, WrapContents = false };
        var view = ActionButton("View QR Code"); view.Click += (_, _) => ViewQrCode();
        var download = ActionButton("Download QR Code as PNG"); download.Click += (_, _) => Download();
        viewPanel.Controls.Add(view); viewPanel.Controls.Add(download);
        root.Controls.Add(viewPanel, 0, 3);

        var printPanel = new FlowLayoutPanel { Dock = DockStyle.Fill, WrapContents = false };
        var print = ActionButton("Print QR Code"); print.Click += (_, _) => Print();
        printPanel.Controls.Add(print);
        root.Controls.Add(printPanel, 0, 4);
        root.Controls.Add(_status, 0, 5);
        Controls.Add(root);
    }

    private void GenerateCode()
    {
        if (!_usingConfiguredUrl || !IsPermanentPublicHttpsUrl(_attendanceUrl, out _))
        {
            _png = null;
            _preview.Image?.Dispose();
            _preview.Image = null;
            _status.Text = "Warning: enter a valid public HTTPS attendance URL before generating a QR code.";
            return;
        }

        using var generator = new QRCodeGenerator();
        using var data = generator.CreateQrCode(_attendanceUrl, QRCodeGenerator.ECCLevel.Q);
        _png = new PngByteQRCode(data).GetGraphic(16);
        using var stream = new MemoryStream(_png);
        using var image = Image.FromStream(stream);
        _preview.Image?.Dispose();
        _preview.Image = new Bitmap(image);
        _status.Text = _usingConfiguredUrl
            ? "Status: configured attendance URL."
            : "Warning: configure the permanent public HTTPS attendance URL before printing.";
    }

    private void SaveAttendanceUrl()
    {
        var value = _urlInput.Text.Trim();
        if (!IsPermanentPublicHttpsUrl(value, out var uri))
        {
            _status.Text = "Warning: enter a valid public HTTPS attendance URL before saving.";
            return;
        }

        try
        {
            _attendanceUrl = uri.ToString();
            _urlInput.Text = _attendanceUrl;
            Directory.CreateDirectory(Path.GetDirectoryName(SettingsFile)!);
            File.WriteAllText(SettingsFile, JsonSerializer.Serialize(new AttendanceSettings(_attendanceUrl), new JsonSerializerOptions { WriteIndented = true }));
            Environment.SetEnvironmentVariable("GYM_ATTENDANCE_URL", _attendanceUrl);
            Environment.SetEnvironmentVariable("GYM_ATTENDANCE_URL", _attendanceUrl, EnvironmentVariableTarget.User);
            _usingConfiguredUrl = true;
            GenerateCode();
            _status.Text = "Status: attendance URL saved and QR code updated.";
        }
        catch (IOException)
        {
            _status.Text = "Warning: the attendance URL could not be saved locally.";
        }
        catch (UnauthorizedAccessException)
        {
            _status.Text = "Warning: permission was denied while saving the attendance URL.";
        }
    }

    private void CopyLink()
    {
        if (string.IsNullOrWhiteSpace(_attendanceUrl))
        {
            MessageBox.Show("Enter a valid public HTTPS attendance URL before copying the link.", "QR Code", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        Clipboard.SetText(_attendanceUrl);
        MessageBox.Show("Attendance link copied to the clipboard.", "QR Code", MessageBoxButtons.OK, MessageBoxIcon.Information);
    }

    private void ViewQrCode()
    {
        GenerateCode();
        if (_png is null) return;

        using var viewer = new Form
        {
            Text = "Attendance QR Code",
            StartPosition = FormStartPosition.CenterParent,
            Size = new Size(560, 680),
            MinimumSize = new Size(420, 520),
            BackColor = Color.White
        };

        var layout = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            Padding = new Padding(20),
            RowCount = 3,
            ColumnCount = 1
        };
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 42));
        layout.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
        layout.RowStyles.Add(new RowStyle(SizeType.Absolute, 70));

        layout.Controls.Add(new Label
        {
            Text = "Scan this code for gym attendance",
            Dock = DockStyle.Fill,
            TextAlign = ContentAlignment.MiddleCenter,
            Font = new Font("Segoe UI", 14, FontStyle.Bold),
            ForeColor = Color.FromArgb(29, 36, 52)
        }, 0, 0);

        var imageBox = new PictureBox
        {
            Dock = DockStyle.Fill,
            SizeMode = PictureBoxSizeMode.Zoom,
            BackColor = Color.White,
            BorderStyle = BorderStyle.FixedSingle,
            Padding = new Padding(12)
        };
        using (var stream = new MemoryStream(_png))
        using (var image = Image.FromStream(stream))
        {
            imageBox.Image = new Bitmap(image);
        }
        layout.Controls.Add(imageBox, 0, 1);

        layout.Controls.Add(new TextBox
        {
            Text = _attendanceUrl,
            ReadOnly = true,
            Dock = DockStyle.Fill,
            Multiline = true,
            ScrollBars = ScrollBars.Horizontal,
            Font = new Font("Segoe UI", 10),
            Margin = new Padding(0, 12, 0, 0)
        }, 0, 2);

        viewer.Controls.Add(layout);
        viewer.FormClosed += (_, _) => imageBox.Image?.Dispose();
        viewer.ShowDialog(this);
    }

    private void Download()
    {
        if (_png is null) return;
        using var dialog = new SaveFileDialog { Filter = "PNG image|*.png", FileName = "universalgym-attendance-qr.png" };
        if (dialog.ShowDialog(this) == DialogResult.OK) File.WriteAllBytes(dialog.FileName, _png);
    }

    private void Print()
    {
        using var dialog = new PrintDialog { Document = _printDocument };
        if (dialog.ShowDialog(this) == DialogResult.OK) _printDocument.Print();
    }

    private void PrintDocument_PrintPage(object? sender, PrintPageEventArgs e)
    {
        if (_preview.Image is null) return;
        if (e.Graphics is not { } graphics) return;
        var size = Math.Min(e.MarginBounds.Width, e.MarginBounds.Height - 80);
        var area = new Rectangle(e.MarginBounds.Left, e.MarginBounds.Top, size, size);
        graphics.DrawImage(_preview.Image, area);
        using var font = new Font("Segoe UI", 12, FontStyle.Bold);
        graphics.DrawString("UniversalGym Attendance", font, Brushes.Black, e.MarginBounds.Left, area.Bottom + 18);
    }

    private static Button ActionButton(string text) => new() { Text = text, AutoSize = true, FlatStyle = FlatStyle.Flat, BackColor = Color.FromArgb(255, 132, 35), ForeColor = Color.White, Margin = new Padding(4) };

    private static (string Url, bool IsConfigured) ResolveAttendanceUrl()
    {
        var configured = LoadSavedAttendanceUrl() ?? Environment.GetEnvironmentVariable("GYM_ATTENDANCE_URL")?.Trim();
        if (IsPermanentPublicHttpsUrl(configured, out var configuredUri))
        {
            return (configuredUri.ToString(), true);
        }

        return ("", false);
    }

    private static string? LoadSavedAttendanceUrl()
    {
        try
        {
            if (!File.Exists(SettingsFile)) return null;
            return JsonSerializer.Deserialize<AttendanceSettings>(File.ReadAllText(SettingsFile))?.AttendanceUrl?.Trim();
        }
        catch (JsonException)
        {
            return null;
        }
        catch (IOException)
        {
            return null;
        }
    }

    private sealed record AttendanceSettings(string AttendanceUrl);

    private static bool IsPermanentPublicHttpsUrl(string? value, out Uri uri)
    {
        uri = null!;
        if (string.IsNullOrWhiteSpace(value) || !Uri.TryCreate(value, UriKind.Absolute, out var candidate) ||
            candidate.Scheme != Uri.UriSchemeHttps || candidate.HostNameType == UriHostNameType.Dns && candidate.Host.Length == 0 ||
            candidate.Host is "localhost" or "0.0.0.0" or "::1" || candidate.Host.EndsWith(".local", StringComparison.OrdinalIgnoreCase) ||
            candidate.Host.Contains("ngrok", StringComparison.OrdinalIgnoreCase) || candidate.Host.EndsWith("loca.lt", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        if (IPAddress.TryParse(candidate.Host, out var address) &&
            (IPAddress.IsLoopback(address) || address.IsIPv6LinkLocal || address.IsIPv6SiteLocal ||
             address.GetAddressBytes()[0] == 10 || address.GetAddressBytes()[0] == 192 && address.GetAddressBytes()[1] == 168 ||
             address.GetAddressBytes()[0] == 172 && address.GetAddressBytes()[1] is >= 16 and <= 31))
        {
            return false;
        }

        uri = candidate;
        return true;
    }

    private static bool StartAttendanceApi()
    {
        if (Environment.GetEnvironmentVariable("GYM_ATTENDANCE_URL") is { Length: > 0 }) return false;
        if (IsAttendanceApiListening()) return true;

        var apiDirectory = FindAttendanceApiDirectory();
        if (apiDirectory is null) return false;

        var apiExecutable = Path.Combine(apiDirectory, "AttendanceApi.exe");
        var apiDll = Path.Combine(apiDirectory, "AttendanceApi.dll");
        try
        {
            ProcessStartInfo startInfo;
            if (File.Exists(apiExecutable))
            {
                startInfo = new ProcessStartInfo(apiExecutable) { WorkingDirectory = apiDirectory, UseShellExecute = true };
            }
            else if (File.Exists(apiDll))
            {
                startInfo = new ProcessStartInfo("dotnet", $"\"{apiDll}\"") { WorkingDirectory = apiDirectory, UseShellExecute = true };
            }
            else
            {
                return false;
            }

            Process.Start(startInfo);
            return true;
        }
        catch (Exception ex) when (ex is InvalidOperationException or System.ComponentModel.Win32Exception)
        {
            return false;
        }
    }

    private static bool IsAttendanceApiListening()
    {
        try
        {
            using var client = new TcpClient();
            return client.ConnectAsync(IPAddress.Loopback, 5080).Wait(200);
        }
        catch (SocketException)
        {
            return false;
        }
    }

    private static string? FindAttendanceApiDirectory()
    {
        var directory = new DirectoryInfo(AppContext.BaseDirectory);
        while (directory is not null)
        {
            var candidate = Path.Combine(directory.FullName, "AttendanceApi", "bin", "Debug", "net8.0");
            if (Directory.Exists(candidate)) return candidate;
            directory = directory.Parent;
        }

        return null;
    }
}
