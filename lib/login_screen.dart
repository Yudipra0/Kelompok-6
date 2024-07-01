import 'dart:async';
import 'dart:convert';

import 'package:bar_app/admin/home_screen.dart';
import 'package:bar_app/config.dart';
import 'package:bar_app/user/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Add a TextEditingController for the email field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("Login successful: ${userCredential.user}");
      _checkUserRole(userCredential.user!.uid, context);
    } catch (e) {
      print('Login failed: $e');
    }
  }

  Future<void> _checkUserRole(String userId, BuildContext context) async {
    String userUrl = '${Config.url}/users/$userId'; // URL untuk tabel pengguna
    String adminUrl = '${Config.url}/admins/$userId'; // URL untuk tabel admin

    try {
      final userResponse = await http.get(Uri.parse(userUrl));
      if (userResponse.statusCode == 200) {
        var data = jsonDecode(userResponse.body);
        var id = data['id_pengguna'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(id: id)),
        );
      }

      final adminResponse = await http.get(Uri.parse(adminUrl));
      if (adminResponse.statusCode == 200) {
        var data = jsonDecode(adminResponse.body);
        var id = data['id_admin'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen(id: id)),
        );
      }
    } catch (e) {
      print('Error checking user existence: $e');
      throw Exception('Failed to check user existence');
    }
  }

  // void _checkUserRole(String userId, BuildContext context) async {
  //   // Ganti URL sesuai dengan URL Firebase Realtime Database Anda
  //   // String url =
  //   //     'https://api-bar-app-default-rtdb.firebaseio.com/api-bar-app/-O-u6sQJBtl8T2x5zP60/users/$userId.json';
  //   String url = '${Config.ngrokUrl}/users/$userId';
  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       var id = data['id_pengguna'];
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage(id: id)),
  //       );

  //     } else {
  //       print('Failed to load user data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error loading user data: $e');
  //   }
  // }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController, // Attach the controller
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.lightBlue[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                  cursorColor: Colors.blueAccent,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.lightBlue[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                  cursorColor: Colors.blueAccent,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _login();
                    // String email = _emailController.text;
                    // if (email.toLowerCase() == 'admin') {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>  AdminHomeScreen()),
                    //   );
                    // } else {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => HomePage()),
                    //   );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10.0),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
