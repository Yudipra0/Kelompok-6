import 'dart:convert';

import 'package:bar_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderHistoryScreen extends StatefulWidget {
  final int id;

  OrderHistoryScreen({Key? key, required this.id}) : super(key: key);
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Map<String, dynamic>> orders = []; // List untuk menyimpan data minuman

  @override
  void initState() {
    super.initState();
    fetchOrders(widget
        .id); // Panggil fungsi fetchDrinks saat widget pertama kali dibuat
  }

  // Fungsi untuk mengambil data minuman dari API
  Future<void> fetchOrders(int id) async {
    final url = '${Config.url}/order/$id'; // Ganti dengan URL API Anda
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Jika pengambilan data berhasil
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        orders = data.cast<Map<String, dynamic>>();
      });
    } else {
      // Jika terjadi kesalahan dalam pengambilan data
      print('Failed to load drinks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Pemesanan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> order = orders[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              child: Text(
                order['namaminuman']![0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              order['namaminuman']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Jumlah: ${order['total']}'),
            trailing: Text(order['status']!),
            onTap: () {
              // Navigasi ke detail pesanan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrderDetailScreen(order: order['id_detailpenjualan']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatefulWidget {
  final int order;

  OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<Map<String, dynamic>> ordersById = [];

  @override
  void initState() {
    super.initState();
    fetchOrdersById(widget.order);
  }

  Future<void> fetchOrdersById(int order) async {
    final url = '${Config.url}/orderDetail/$order'; // Ganti dengan URL API Anda
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        ordersById = [data]; // Wrap the single order in a list
      });
    } else {
      print('Failed to load orders');
    }
  }

  void _showEditDialog(Map<String, dynamic> order) {
    final TextEditingController _controller =
        TextEditingController(text: order['total'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Total'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter new total"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editTotal(order['id_detailpenjualan'],
                    int.parse(_controller.text), order['harga']);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTotal(int id, int newTotal, int harga) async {
    int total_harga = newTotal * harga;
    final url = '${Config.url}/order/edit/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"total": newTotal, "total_harga": total_harga}),
    );

    if (response.statusCode == 200) {
      setState(() {
        ordersById.firstWhere(
            (order) => order['id_detailpenjualan'] == id)['total'] = newTotal;
      });
    } else {
      print('Failed to update total');
    }
  }

  void showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Order Detail'),
          content: Text('Are you sure you want to delete?'),
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
                _deleteOrder(id); // Panggil fungsi delete
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(int id) async {
    final url = '${Config.url}/order/delete/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        ordersById.removeWhere((order) => order['id_detailpenjualan'] == id);
      });
    } else {
      print('Failed to delete order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ordersById.map((order) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['namaminuman'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text('Jumlah: ${order['total']}'),
                  SizedBox(height: 8.0),
                  Text('Tanggal Pesanan: ${order['tanggal']}'),
                  SizedBox(height: 8.0),
                  Text('Status: ${order['status']}'),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _showEditDialog(
                          order,
                        ),
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () => showDeleteConfirmationDialog(
                            order['id_detailpenjualan']),
                        child:
                            Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
