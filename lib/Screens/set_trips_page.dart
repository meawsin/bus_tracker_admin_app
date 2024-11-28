import 'package:flutter/material.dart';

class SetTripsPage extends StatelessWidget {
  const SetTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Trips',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Open trip creation form
              },
              child: const Text('Create New Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
