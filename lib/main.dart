import 'package:bus_tracker_admin_app/Screens/dashboardPage.dart';
import 'package:bus_tracker_admin_app/Screens/login_page.dart';
import 'package:bus_tracker_admin_app/Screens/manage_buses_page.dart';
import 'package:bus_tracker_admin_app/Screens/manage_drivers_page.dart';
import 'package:bus_tracker_admin_app/Screens/set_trips_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for async initialization
  await initializeDateFormatting(
      'bn_BD', null); // Initialize Bangla date formatting
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminName') != null; // Check if adminName exists
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      routes: {
        '/dashboard': (context) => const DashboardPage(),
        '/manageBuses': (context) => const ManageBusesPage(),
        '/manageDrivers': (context) => const ManageDriversPage(),
        '/setTrips': (context) => const SetTripsPage(),
        // '/routes': (context) => RoutesPage(),
        // '/stats': (context) => StatsPage(),
        //'/complaints': (context) => ComplaintsPage(),
        '/login': (context) => const LoginPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for the login status
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data == true) {
            // User is logged in, go to Dashboard
            return const DashboardPage();
          } else {
            // User is not logged in, go to Login Page
            return const LoginPage();
          }
        },
      ),
    );
  }
}
