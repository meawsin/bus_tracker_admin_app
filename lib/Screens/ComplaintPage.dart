import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplaintsPage extends StatefulWidget {
  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  List<Map<String, dynamic>> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    final response = await http
        .get(Uri.parse('http://192.168.56.1/bus_tracker/fetch_data.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        complaints =
            List<Map<String, dynamic>>.from(data['data']['complaints']);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load complaints');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complaints")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final complaint = complaints[index];
                return ListTile(
                  title: Text(
                      complaint['complaintDescription'] ?? 'No Description'),
                  subtitle: Row(
                    children: [
                      Text("Status: "),
                      DropdownButton<String>(
                        value: complaint['Status'],
                        items: <String>['Pending', 'Resolved', 'In Progress']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newStatus) {
                          if (newStatus != null) {
                            // Update complaint status
                            updateComplaintStatus(complaint['id'], newStatus);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> updateComplaintStatus(int id, String status) async {
    final response = await http.post(
      Uri.parse('http://192.168.56.1/bus_tracker/update_complaint_status.php'),
      body: {
        'id': id.toString(),
        'status': status,
      },
    );

    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      // Update the complaint status locally
      setState(() {
        complaints.firstWhere((complaint) => complaint['id'] == id)['Status'] =
            status;
      });
    } else {
      print('Failed to update status');
    }
  }
}
