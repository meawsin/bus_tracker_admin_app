import 'package:bus_tracker_admin_app/Screens/dashboardPage.dart';
import 'package:bus_tracker_admin_app/Screens/login_page.dart';
import 'package:bus_tracker_admin_app/Screens/manage_buses_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for async initialization
  await initializeDateFormatting(
      'bn_BD', null); // Initialize Bangla date formatting
  runApp(AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      routes: {
        '/manageBuses': (context) =>
            ManageBusesPage(), // This is your ManageBuses page
        '/login': (context) => LoginPage(), // Example for login route
        '/dashboard': (context) => DashboardPage(),
        // other routes
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}
