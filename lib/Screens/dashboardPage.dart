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
  String adminName = "Admin";
  String currentDateTime = "";

  @override
  void initState() {
    super.initState();
    fetchAdminName();
    updateDateTime();
  }

  void fetchAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('adminName') ?? "Admin";
    });
  }

  void updateDateTime() {
    setState(() {
      final now = DateTime.now();
      final banglaDateFormatter = DateFormat("dd MMMM yyyy", "bn_BD");
      final banglaTimeFormatter = DateFormat("h:mm:ss a", "bn_BD");
      currentDateTime =
          "${banglaDateFormatter.format(now)} | ${banglaTimeFormatter.format(now)}";
    });

    Future.delayed(const Duration(seconds: 1), updateDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        adminName: adminName,
        currentDateTime: currentDateTime,
        onLogoutPressed: () => logout(context),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/setTrips');
              },
              icon: const Icon(Icons.add),
              label: const Text("Assign a Trip"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 4, 54, 19)),
            ),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              children: [
                _buildStatCard("On Route Buses", "5", Icons.directions_bus),
                _buildStatCard("Today's Trips", "12", Icons.schedule),
                _buildStatCard("Free Drivers", "8", Icons.person_outline),
                _buildStatCard("Free Buses", "3", Icons.directions_bus_filled),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Complaints'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => Navigator.pushNamed(context, '/Complaints'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.lightGreen[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(height: 8),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(value,
                style: const TextStyle(fontSize: 24, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Admin Panel',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pushNamed(context, '/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.directions_bus),
            title: const Text('Buses'),
            onTap: () => Navigator.pushNamed(context, '/buses'),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Drivers'),
            onTap: () => Navigator.pushNamed(context, '/drivers'),
          ),
          ListTile(
            leading: const Icon(Icons.route),
            title: const Text('Routes'),
            onTap: () => Navigator.pushNamed(context, '/routes'),
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Complaints'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              debugPrint("Complaints button clicked");
              Navigator.pushNamed(context, '/complaints');
            },
          ),
        ],
      ),
    );
  }

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
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmLogout) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
