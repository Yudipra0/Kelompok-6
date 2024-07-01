import 'package:bar_app/widgets/cocktail_page.dart'; // Import halaman baru
import 'package:bar_app/widgets/home_nav_bar.dart';
import 'package:bar_app/widgets/juice_page.dart'; // Import halaman baru
import 'package:bar_app/widgets/mocktail_page.dart'; // Import halaman baru
import 'package:bar_app/widgets/search_page.dart'; // Import halaman pencarian
import 'package:bar_app/widgets/smoothies_page.dart'; // Import halaman baru
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final int id;

  HomePage({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.sort_rounded,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(id: id),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Customer Service'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context); // Menutup drawer
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "DrinksDrift",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Order now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(),
                  labelStyle: TextStyle(fontSize: 20),
                  labelPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  tabs: [
                    Tab(text: "Cocktail"),
                    Tab(text: "Mocktail"),
                    Tab(text: "Smoothies"),
                    Tab(text: "Juice"),
                  ],
                ),
                Flexible(
                  flex: 1,
                  child: TabBarView(
                    children: [
                      CocktailPage(id: id), // Menampilkan halaman CocktailPage
                      MocktailPage(id: id), // Menampilkan halaman MocktailPage
                      SmoothiesPage(
                          id: id), // Menampilkan halaman SmoothiesPage
                      JuicePage(id: id), // Menampilkan halaman JuicePage
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: HomeNavBar(id: id),
      ),
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
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implementasikan aksi keluar
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
