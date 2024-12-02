import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For JSON decoding
import 'package:bus_tracker_admin_app/Widgets/CustomAppBar.dart';

class ManageBusesPage extends StatefulWidget {
  const ManageBusesPage({super.key});

  @override
  _ManageBusesPageState createState() => _ManageBusesPageState();
}

class _ManageBusesPageState extends State<ManageBusesPage> {
  List<Map<String, dynamic>> buses = [];
  List<Map<String, dynamic>> filteredBuses = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();
  String adminName = "Admin";
  String currentDateTime = "";

  @override
  void initState() {
    super.initState();
    fetchBuses();
    updateDateTime();
    searchController.addListener(_filterBuses);
  }

  Future<void> fetchBuses() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final response = await http
          .get(Uri.parse('http://192.168.56.1/bus_tracker/get_buses.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          buses = data.map((bus) => bus as Map<String, dynamic>).toList();
          filteredBuses = List.from(buses);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load buses. Please try again.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to load buses. Please check your internet connection.';
        isLoading = false;
      });
    }
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

  void _filterBuses() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredBuses = buses.where((bus) {
        return bus['name'].toLowerCase().contains(query) ||
            bus['license_plate'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void onAddBusPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBusPage(isEditing: false)),
    );
  }

  void onEditBusPressed(Map<String, dynamic> bus) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditBusPage(isEditing: true, bus: bus)),
    );
  }

  void onDeleteBusPressed(Map<String, dynamic> busId) async {
    final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Confirmation'),
              content: const Text('Are you sure you want to delete this bus?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.56.1/bus_tracker/delete_bus.php'),
          body: {'bus_id': busId['id'].toString()},
        );
        if (response.statusCode == 200) {
          setState(() {
            buses.removeWhere((bus) => bus['id'] == busId['id']);
            filteredBuses.removeWhere((bus) => bus['id'] == busId['id']);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bus deleted successfully')),
          );
        } else {
          throw Exception('Failed to delete bus');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete bus')),
        );
      }
    }
  }

  DataRow buildBusTile(Map<String, dynamic> bus) {
    return DataRow(
      cells: [
        DataCell(Text(bus['name'])),
        DataCell(Text(bus['license_plate'])),
        DataCell(Text(bus['status'])),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onEditBusPressed(bus),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDeleteBusPressed(bus),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        adminName: adminName,
        currentDateTime: currentDateTime,
        onLogoutPressed: () {
          // Handle logout action
        },
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Buses',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Expanded(
                    child: filteredBuses.isEmpty
                        ? const Center(child: Text('No buses available.'))
                        : DataTable(
                            columns: const [
                              DataColumn(label: Text('Bus Name')),
                              DataColumn(label: Text('License Plate')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: filteredBuses
                                .map((bus) => buildBusTile(bus))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddBusPressed(context),
        backgroundColor: Colors.green,
        tooltip: 'Add New Bus',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddEditBusPage extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? bus;

  const AddEditBusPage({super.key, required this.isEditing, this.bus});

  @override
  _AddEditBusPageState createState() => _AddEditBusPageState();
}

class _AddEditBusPageState extends State<AddEditBusPage> {
  late TextEditingController _nameController;
  late TextEditingController _licensePlateController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.bus != null) {
      _nameController = TextEditingController(text: widget.bus!['name']);
      _licensePlateController =
          TextEditingController(text: widget.bus!['license_plate']);
      _statusController = TextEditingController(text: widget.bus!['status']);
    } else {
      _nameController = TextEditingController();
      _licensePlateController = TextEditingController();
      _statusController = TextEditingController();
    }
  }

  Future<void> submitForm() async {
    final String name = _nameController.text;
    final String licensePlate = _licensePlateController.text;
    final String status = _statusController.text;

    if (name.isEmpty || licensePlate.isEmpty || status.isEmpty) {
      return;
    }

    final url = widget.isEditing
        ? 'http://192.168.56.1/bus_tracker/edit_bus.php'
        : 'http://192.168.56.1/bus_tracker/add_bus.php';

    final response = await http.post(Uri.parse(url), body: {
      'name': name,
      'license_plate': licensePlate,
      'status': status,
      'bus_id': widget.isEditing ? widget.bus!['id'].toString() : null,
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEditing ? 'Bus updated' : 'Bus added')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save bus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.isEditing ? 'Edit Bus' : 'Add New Bus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Bus Name'),
            ),
            TextField(
              controller: _licensePlateController,
              decoration: const InputDecoration(labelText: 'License Plate'),
            ),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitForm,
              child: Text(widget.isEditing ? 'Update Bus' : 'Add Bus'),
            ),
          ],
        ),
      ),
    );
  }
}
