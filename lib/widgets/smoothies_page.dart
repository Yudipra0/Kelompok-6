import 'dart:convert';

import 'package:bar_app/config.dart';
import 'package:bar_app/widgets/single_item_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SmoothiesPage extends StatefulWidget {
  final int id;

  SmoothiesPage({Key? key, required this.id}) : super(key: key);
  @override
  _SmoothiesPageState createState() => _SmoothiesPageState();
}

class _SmoothiesPageState extends State<SmoothiesPage> {
  List<Map<String, dynamic>> drinks = [];

  @override
  void initState() {
    super.initState();
    fetchDrinks();
  }

  Future<void> fetchDrinks() async {
    final url = '${Config.url}/minuman/coctail'; // Ganti dengan URL API Anda
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Jika pengambilan data berhasil
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        drinks = data.cast<Map<String, dynamic>>();
      });
    } else {
      // Jika terjadi kesalahan dalam pengambilan data
      print('Failed to load drinks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: drinks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: drinks.map((drink) {
                    return Column(
                      children: [
                        _buildCocktailBox(
                          context,
                          drink['namaminuman'],
                          drink['deskripsi'],
                          drink['image'], // Assuming API returns image path
                          drink,
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  Widget _buildCocktailBox(BuildContext context, String title, String subtitle,
      String imagePath, Map<String, dynamic> drink) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
        borderRadius:
            BorderRadius.circular(10), // Tambahan untuk sudut melengkung
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SingleItemPage(drink: drink, id: widget.id)),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              child: Image.network(
                imagePath, // Menggunakan path gambar yang diberikan
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
