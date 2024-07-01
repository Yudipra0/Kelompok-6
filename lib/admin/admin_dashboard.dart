import 'package:bar_app/admin/manage_drink.dart';
import 'package:bar_app/admin/manage_order.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to manage orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageOrdersScreen()),
                  );
                },
                child: Text('Manage Orders'),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to manage drinks screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageDrinksScreen()),
                  );
                },
                child: Text('Manage Drinks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}