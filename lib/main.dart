import 'dart:io';

import 'package:bar_app/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:bar_app/widgets/single_item_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Menggunakan kondisional untuk menginisialisasi Firebase sesuai platform
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyASFH3IChrP71Cip-ChRVJOi3jEuvdzMKc',
      appId: '1:994501041619:android:ba5a9d5e8c105ed5b7a326',
      messagingSenderId: '994501041619',
      projectId: 'uas-kelompok-6',
      storageBucket: 'uas-kelompok-6.appspot.com',
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar App',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Mengubah warna tema menjadi ungu
      ),
      initialRoute: '/login', // Set rute awal ke halaman login
      routes: {
        '/login': (context) =>
            const LoginScreen(), // Menambahkan rute ke halaman login
        // 'singleItempage': (context) =>
        //     SingleItemPage(drink: drink,), // Menambahkan rute ke halaman home
      },
    );
  }
}
