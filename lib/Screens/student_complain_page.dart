import 'package:flutter/material.dart';

class StudentComplaintsPage extends StatelessWidget {
  const StudentComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Complaints',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Replace with dynamic count
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Complaint #${index + 1}'),
                      subtitle: const Text('Details of the complaint here'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Mark as resolved
                        },
                        child: const Text('Resolve'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
