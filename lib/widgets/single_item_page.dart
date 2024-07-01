import 'dart:convert';

import 'package:bar_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SingleItemPage extends StatefulWidget {
  final Map<String, dynamic> drink;
  final int id;

  // SingleItemPage({Key? key, required this.id}) : super(key: key);

  SingleItemPage({required this.drink, required this.id});

  @override
  _SingleItemPageState createState() => _SingleItemPageState();
}

class _SingleItemPageState extends State<SingleItemPage> {
  int _itemCount = 1;

  void _increaseItemCount() {
    setState(() {
      _itemCount++;
    });
  }

  void _decreaseItemCount() {
    if (_itemCount > 1) {
      setState(() {
        _itemCount--;
      });
    }
  }

  void _checkout(id_minuman, int id_pengguna) {
    int harga =
        widget.drink['harga']; // Asumsikan harga tersedia dalam data minuman
    int totalHarga = _itemCount * harga;
    // Navigasi ke halaman checkout atau tampilkan dialog untuk checkout
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Checkout"),
          content: Text("Anda telah memilih $_itemCount item."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Implementasikan logika checkout di sini
                saveCheckout(id_minuman, _itemCount, id_pengguna, totalHarga);
                // Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveCheckout(
      int idMinuman, int total, int idPengguna, int totalHarga) async {
    final String apiUrl =
        '${Config.url}/order/add'; // Ganti dengan URL API Anda

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_pengguna': idPengguna,
        'id_minuman': idMinuman,
        'total': total,
        'total_harga': totalHarga,
      }),
    );

    if (response.statusCode == 200) {
      // Jika berhasil, tampilkan pesan sukses atau navigasi ke halaman lain
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checkout berhasil!'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      // Jika gagal, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal melakukan checkout: ${response.reasonPhrase}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 25, left: 10, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris dengan ikon back
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Tambahkan sedikit jarak

              // Container untuk gambar
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Image.network(
                  widget.drink['image'], // Menggunakan path gambar dari data
                  height: MediaQuery.of(context).size.height / 1.7,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 10), // Tambahkan sedikit jarak

              // Baris untuk judul dan kuantitas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.drink['namaminuman'],
                            overflow: TextOverflow
                                .ellipsis, // Menampilkan ... jika teks terlalu panjang
                            maxLines: 1, // Maksimal satu baris teks
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: _decreaseItemCount,
                              child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "-", // Placeholder untuk tanda minus
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 5), // Tambahkan jarak antara kontainer
                            Text(
                              '$_itemCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                                width: 5), // Tambahkan jarak antara kontainer
                            InkWell(
                              onTap: _increaseItemCount,
                              child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "+", // Placeholder untuk tanda plus
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15), // Tambahkan sedikit jarak
                  Text(
                    widget.drink['deskripsi'], // Deskripsi atau detail lainnya
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10), // Tambahkan sedikit jarak
                  Text(
                    'Rp. ${widget.drink['harga'].toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // Spacer untuk mendorong tombol checkout ke bawah
              Spacer(),

              // Tombol Checkout
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _checkout(widget.drink['id_minuman'], widget.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text("Checkout"),
                ),
              ),
              SizedBox(height: 20), // Tambahkan jarak di bawah tombol checkout
            ],
          ),
        ),
      ),
    );
  }
}
