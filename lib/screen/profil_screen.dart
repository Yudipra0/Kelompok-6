// ProfileScreen.dart
import 'dart:convert';

import 'package:bar_app/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatelessWidget {
  final int id;

  ProfileScreen({Key? key, required this.id}) : super(key: key);

  Future<Map<String, dynamic>?> fetchProfileData() async {
    final url =
        Uri.parse('${Config.url}/user/$id'); // Ganti URL dengan URL API Anda
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Jika permintaan sukses, parse data JSON
      return json.decode(response.body);
    } else {
      // Jika gagal, tampilkan pesan kesalahan
      throw Exception('Failed to load profile data');
    }
  }

  final String profilePictureUrl = 'https://via.placeholder.com/150';
  final String name = 'Kelompok 6';
  final String bio = 'Pemograman Mobile';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchProfileData(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data found'));
        } else {
          // Data berhasil dimuat, tampilkan UI profil
          final profileData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.blueAccent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profilePictureUrl),
                    ),
                    SizedBox(height: 10),
                    Text(
                      profileData['nama'],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      profileData['alamat'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    _buildListTile(
                        context, Icons.logout, 'Log Out', Colors.red),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildListTile(
      BuildContext context, IconData icon, String title, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      onTap: () {
        // Implementasikan aksi untuk setiap item
        if (title == 'Log Out') {
          _showLogoutDialog(context);
        }
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      tileColor: Colors.grey[200],
      selectedTileColor: Colors.grey[300],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implementasikan aksi keluar
                logout(context);
              },
              child: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  // Navigasi ke halaman login atau halaman lain setelah logout
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
