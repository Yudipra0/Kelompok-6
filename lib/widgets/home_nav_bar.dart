import 'package:bar_app/screen/profil_screen.dart';
import 'package:bar_app/screen/riwayat_screen.dart';
import 'package:flutter/material.dart';

class HomeNavBar extends StatelessWidget {
  final int id;

  HomeNavBar({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Spacer(),
          IconButton(
            icon: Icon(Icons.shopping_cart_checkout,
                color: Colors.white, size: 35),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderHistoryScreen(id: id)),
              );
            },
          ),
          Spacer(flex: 2),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white, size: 35),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(id: id)),
              );
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}
