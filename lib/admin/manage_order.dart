import 'package:bar_app/admin/view_order.dart';
import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Orders',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to view orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewOrdersScreen()),
                  );
                },
                child: Text('View Orders'),
              ),
              SizedBox(height: 10.0),
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigate to add order screen
              //   //   Navigator.push(
              //   //     context,
              //   //     MaterialPageRoute(builder: (context) => AddOrderScreen()),
              //   //   );
              //  },
              //  child: Text('Add Order'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
