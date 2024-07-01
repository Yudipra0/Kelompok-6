import 'package:bar_app/admin/manage_drink.dart';
import 'package:bar_app/admin/manage_order.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  final int id;

  AdminHomeScreen({Key? key, required this.id}) : super(key: key);

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Mengarahkan ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _navigateToLogin(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, Admin!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to manage drinks screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageDrinksScreen(),
                    ),
                  );
                },
                child: Text('Manage Drinks'),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to manage orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageOrdersScreen(),
                    ),
                  );
                },
                child: Text('Manage Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
