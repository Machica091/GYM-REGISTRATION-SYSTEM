using GymRegistrationApp.Forms;
using GymRegistrationApp.Services;

namespace GymRegistrationApp;

internal static class Program
{
    [STAThread]
    private static void Main()
    {
        ApplicationConfiguration.Initialize();
        DataStore.Initialize();

        // Test database connection to XAMPP MySQL
        bool dbConnected = DatabaseConnection.TestConnection();
        if (!dbConnected)
        {
            MessageBox.Show(
                "Warning: Could not connect to the database. Please ensure XAMPP MySQL is running.\n\n" +
                "Connection details:\n" +
                "Server: 127.0.0.1\n" +
                "User: root\n" +
                "Database: gym_registration_db\n\n" +
                "The application will continue using local data storage.",
                "Database Connection Warning",
                MessageBoxButtons.OK,
                MessageBoxIcon.Warning);
        }

        Application.Run(new LoginForm());
    }
}
