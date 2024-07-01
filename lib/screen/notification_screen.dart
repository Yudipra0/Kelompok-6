import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Message',
      'description': 'You have received a new message eka.',
      'time': '2m ago',
      'icon': Icons.message,
    },
    {
      'title': 'New Like',
      'description': 'Agus liked your post.',
      'time': '5m ago',
      'icon': Icons.thumb_up,
    },
    {
      'title': 'New Comment',
      'description': 'Yudi commented on your photo.',
      'time': '10m ago',
      'icon': Icons.comment,
    },
    // Tambahkan notifikasi lainnya di sini...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: Icon(
                  notification['icon'],
                  color: Colors.white,
                ),
              ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(notification['description']),
              trailing: Text(notification['time']),
              onTap: () {
                // Implementasikan aksi pada notifikasi
              },
            ),
          );
        },
      ),
    );
  }
}
