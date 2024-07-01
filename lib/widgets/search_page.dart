import 'dart:convert';

import 'package:bar_app/config.dart';
import 'package:bar_app/widgets/single_item_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatelessWidget {
  final int id;

  SearchPage({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchForm(id: id),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  final int id;

  SearchForm({Key? key, required this.id}) : super(key: key);
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> drinks = [];

  @override
  void initState() {
    super.initState();
    // fetchDrinks(); // Panggil fungsi fetchDrinks saat widget pertama kali dibuat
  }

  // Fungsi untuk mengambil data minuman dari API
  Future<void> fetchDrinks(String keyword) async {
    final url = '${Config.url}/minuman/search'; // Ganti dengan URL API Anda
    final response = await http.get(Uri.parse('$url?s=$keyword'));

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
    return Column(
      children: <Widget>[
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Enter drink name',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _performSearch(context, _searchController.text.trim());
              },
            ),
          ),
          onSubmitted: (value) {
            _performSearch(context, value.trim());
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              final drink = drinks[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SingleItemPage(drink: drink, id: widget.id),
                    ),
                  );
                },
                child: ListTile(
                  leading: Image.network(
                    drink[
                        'image'], // Ganti dengan key yang sesuai dengan URL gambar
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(drink['namaminuman']),
                  subtitle: Text(drink['deskripsi']),
                  // Tambahkan aksi atau navigasi jika diperlukan
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _performSearch(BuildContext context, String keyword) {
    fetchDrinks(keyword);
    // Implement your search logic here
    // For demonstration, just show a snackbar with the search query
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for: $keyword'),
      ),
    );

    // You can perform actual search operations here, such as querying a database
    // or filtering a list based on the search keyword.
  }
}
