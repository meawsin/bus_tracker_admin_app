import 'package:flutter/material.dart';
import 'package:bus_tracker_admin_app/Screens/manage_drivers_page.dart';
import 'package:bus_tracker_admin_app/Screens/manage_buses_page.dart';
import 'package:bus_tracker_admin_app/Screens/set_trips_page.dart';
import 'package:bus_tracker_admin_app/Screens/student_complain_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ManageBusesPage(),
    ManageDriversPage(),
    SetTripsPage(),
    StudentComplaintsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Admin Panel',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bus_alert),
              title: const Text('Manage Buses'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Manage Drivers'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Set Trips'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Student Complaints'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
