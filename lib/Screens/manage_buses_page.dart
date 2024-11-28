import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

class ManageBusesPage extends StatefulWidget {
  const ManageBusesPage({super.key});

  @override
  _ManageBusesPageState createState() => _ManageBusesPageState();
}

class _ManageBusesPageState extends State<ManageBusesPage> {
  List<Map<String, dynamic>> buses =
      []; // List to store buses from the database
  bool isLoading = true; // Loading state to show loading spinner

  @override
  void initState() {
    super.initState();
    fetchBuses(); // Fetch buses on screen load
  }

  Future<void> fetchBuses() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/bus_tracker/get_buses.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        buses = data.map((bus) => bus as Map<String, dynamic>).toList();
        isLoading = false; // Stop the loading spinner
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load buses');
    }
  }

  // Build Bus Tile
  Widget buildBusTile(Map<String, dynamic> bus) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      child: ListTile(
        leading: const Icon(Icons.bus_alert),
        title: Text(bus['name']),
        subtitle:
            Text('Plate: ${bus['license_plate']} - Status: ${bus['status']}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle bus tap (view details, last trip, etc.)
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Buses'),
        backgroundColor: const Color(0xFF16501d), // Dark Green
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : ListView.builder(
              itemCount: buses.length,
              itemBuilder: (context, index) {
                var bus = buses[index];
                return buildBusTile(bus);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Tapped");
          Navigator.pushNamed(context, '/addBus');
        },
        backgroundColor: const Color(0xFF16501d),
        tooltip: 'Add New Bus',
        child: Icon(Icons.add),
      ),
    );
  }
}
