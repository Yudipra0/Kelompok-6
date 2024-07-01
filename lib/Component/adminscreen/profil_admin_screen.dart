import 'package:flutter/material.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              // Display admin's profile picture
              backgroundImage: AssetImage('assets/images/kue1.jpg'),
            ),
            const SizedBox(height: 20),
            Text(
              'Admin Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'admin@example.com',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 0, 200, 255),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile screen
              },
              child: Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Log out functionality
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
