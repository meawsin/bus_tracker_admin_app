import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String adminName;
  final String currentDateTime;
  final VoidCallback onLogoutPressed;

  const CustomAppBar({
    super.key,
    required this.adminName,
    required this.currentDateTime,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF16501d), // Dark green
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Text(
            currentDateTime,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            "Welcome, $adminName!",
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: onLogoutPressed, // Trigger the logout logic
        ),
      ],
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu, // Replace this with your desired icon
            size: 28.0,
            color: Colors.white, // Icon color
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Opens the drawer
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // AppBar height
}
