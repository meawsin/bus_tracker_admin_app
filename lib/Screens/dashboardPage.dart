import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_tracker_admin_app/Widgets/CustomAppBar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String adminName = "Admin"; // Default admin name
  String currentDateTime = ""; // To store formatted date & time

  @override
  void initState() {
    super.initState();
    fetchAdminName();
    updateDateTime();
  }

  // Fetch the admin name (simulate login info or from SharedPreferences)
  void fetchAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName =
          prefs.getString('adminName') ?? "Admin"; // Use stored name or default
    });
  }

  // Update Bangla date and time
  void updateDateTime() {
    setState(() {
      final now = DateTime.now();
      final banglaDateFormatter = DateFormat("dd MMMM yyyy", "bn_BD");
      final banglaTimeFormatter = DateFormat("h:mm:ss a", "bn_BD");

      currentDateTime =
          "${banglaDateFormatter.format(now)} | ${banglaTimeFormatter.format(now)}";
    });

    // Update every second for real-time clock
    Future.delayed(const Duration(seconds: 1), updateDateTime);
  }

  // Logout logic
  void logout(BuildContext context) async {
    final bool confirmLogout = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logout Confirmation'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                ),
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if the dialog is dismissed.

    if (confirmLogout) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all stored data
      Navigator.pushReplacementNamed(
          context, '/login'); // Navigate to login page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        adminName: adminName,
        currentDateTime: currentDateTime,
        onLogoutPressed: () => logout(context),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.bus_alert),
              title: const Text('Manage Buses'),
              onTap: () {
                Navigator.pushNamed(context, '/manageBuses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Manage Drivers'),
              onTap: () {
                Navigator.pushNamed(context, '/manageDrivers');
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Set Trips'),
              onTap: () {
                Navigator.pushNamed(context, '/setTrips');
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Routes'),
              onTap: () {
                Navigator.pushNamed(context, '/routes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Stats'),
              onTap: () {
                Navigator.pushNamed(context, '/stats');
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Complaints'),
              onTap: () {
                Navigator.pushNamed(context, '/complaints');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 6, // Display 3 buttons per row
          crossAxisSpacing: 10.0, // Reduced spacing between buttons
          mainAxisSpacing: 15.0,
          childAspectRatio: 1.2, // Adjust the height-to-width ratio
          children: [
            _buildDashboardButton(
              icon: Icons.bus_alert,
              label: "Manage Buses",
              onPressed: () {
                Navigator.pushNamed(context, '/manageBuses');
              },
            ),
            _buildDashboardButton(
              icon: Icons.person,
              label: "Manage Drivers",
              onPressed: () {
                Navigator.pushNamed(context, '/manageDrivers');
              },
            ),
            _buildDashboardButton(
              icon: Icons.schedule,
              label: "Set Trips",
              onPressed: () {
                Navigator.pushNamed(context, '/setTrips');
              },
            ),
            _buildDashboardButton(
              icon: Icons.map,
              label: "Routes",
              onPressed: () {
                Navigator.pushNamed(context, '/routes');
              },
            ),
            _buildDashboardButton(
              icon: Icons.bar_chart,
              label: "Stats",
              onPressed: () {
                Navigator.pushNamed(context, '/stats');
              },
            ),
            _buildDashboardButton(
              icon: Icons.feedback,
              label: "Complaints",
              onPressed: () {
                Navigator.pushNamed(context, '/complaints');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFd7e8dc), // Light green
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFF16501d)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: const Color(0xFF16501d)),
            const SizedBox(height: 10.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16501d),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
