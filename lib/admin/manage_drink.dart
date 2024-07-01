import 'dart:convert';

import 'package:bar_app/config.dart';
import 'package:bar_app/crud%20admin/add_drink.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageDrinksScreen extends StatefulWidget {
  @override
  _ManageDrinksScreenState createState() => _ManageDrinksScreenState();
}

class _ManageDrinksScreenState extends State<ManageDrinksScreen> {
  List<Map<String, dynamic>> drinks = []; // List untuk menyimpan data minuman
  int currentPage = 1; // Halaman saat ini
  bool isLoading = false; // Apakah data sedang dimuat
  bool hasMoreData = true; // Apakah masih ada data untuk dimuat

  @override
  void initState() {
    super.initState();
    fetchDrinks(
        currentPage); // Panggil fungsi fetchDrinks saat widget pertama kali dibuat
  }

  // Fungsi untuk mengambil data minuman dari API
  Future<void> fetchDrinks(int page) async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    final url = '${Config.url}/minuman?page=$page'; // Ganti dengan URL API Anda
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Jika pengambilan data berhasil
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        drinks.addAll(data.cast<Map<String, dynamic>>());
        isLoading = false;
        if (data.isEmpty) {
          hasMoreData = false;
        }
      });
    } else {
      // Jika terjadi kesalahan dalam pengambilan data
      setState(() {
        isLoading = false;
      });
      print('Failed to load drinks');
    }
  }

  // Fungsi untuk menghapus minuman berdasarkan id_minuman
  Future<void> deleteDrink(int idMinuman) async {
    final url =
        '${Config.url}/delete/minuman/$idMinuman'; // Ganti dengan URL delete API Anda
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      // Jika penghapusan berhasil
      setState(() {
        drinks.removeWhere((drink) => drink['id_minuman'] == idMinuman);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Drink deleted successfully')),
      );
    } else {
      // Jika terjadi kesalahan dalam penghapusan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete drink')),
      );
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi delete
  void showDeleteConfirmationDialog(int idMinuman, String namaMinuman) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Drink'),
          content: Text('Are you sure you want to delete $namaMinuman?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                deleteDrink(idMinuman); // Panggil fungsi delete
              },
            ),
          ],
        );
      },
    );
  }

  void updateDrink(
      int idMinuman, String newName, String newDescription, int price) async {
    final String apiUrl =
        '${Config.url}/update/minuman/$idMinuman'; // Ganti dengan URL endpoint update drink Anda

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'name': newName,
          'description': newDescription,
          'price': price.toString(),
        },
      );

      if (response.statusCode == 200) {
        // Berhasil diupdate
        fetchDrinks(currentPage);
        print('Drink updated successfully');
        // Tambahkan kode lain jika perlu
      } else {
        // Gagal update
        print('Failed to update drink');
        // Tambahkan kode lain jika perlu
      }
    } catch (e) {
      // Tangani error
      print('Error updating drink: $e');
      // Tambahkan kode lain jika perlu
    }
  }

  void showEditDialog(BuildContext context, Map<String, dynamic> drink) {
    TextEditingController nameController =
        TextEditingController(text: drink['namaminuman']);
    TextEditingController descriptionController =
        TextEditingController(text: drink['deskripsi']);
    TextEditingController priceController =
        TextEditingController(text: drink['harga']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Drink'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Drink Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Implement save functionality here
                String newName = nameController.text;
                String newDescription = descriptionController.text;
                String newPrice = priceController.text;
                int price = int.tryParse(newPrice) ?? 0;

                // Call function to update drink using API or other method
                updateDrink(
                    drink['id_minuman'], newName, newDescription, price);

                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void loadMoreDrinks() {
    if (!isLoading && hasMoreData) {
      setState(() {
        currentPage++;
      });
      fetchDrinks(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Drinks'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Drinks',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to add drink screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDrinkScreen()),
                  );
                },
                child: Text('Add Drink'),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      drinks.length + 1, // Tambahkan 1 untuk indikator pemuatan
                  itemBuilder: (context, index) {
                    if (index == drinks.length) {
                      return isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Container();
                    }
                    Map<String, dynamic> drink = drinks[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(
                          drink['image'] ?? '',
                        ),
                      ),
                      title: Text(
                        drink['namaminuman'] ?? '',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.0),
                          Text(
                            'Description: ${drink['deskripsi'] ?? ''}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Price: ${drink['harga'] ?? ''}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showEditDialog(context, drink);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red), // Set the color to red
                            onPressed: () {
                              // Tampilkan dialog konfirmasi delete
                              showDeleteConfirmationDialog(
                                drink['id_minuman'],
                                drink['namaminuman'],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
