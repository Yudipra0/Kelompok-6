import 'dart:convert';

import 'package:bar_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewOrdersScreen extends StatefulWidget {
  @override
  _ViewOrdersScreenState createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreen> {
  late Future<List<Map<String, dynamic>>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final response = await http.get(Uri.parse('${Config.url}/order'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> orders = [];
      List<dynamic> jsonData = json.decode(response.body);

      jsonData.forEach((orderData) {
        Map<String, dynamic> order = {
          'id': orderData['id_detailpenjualan'],
          'customerName': orderData['namaminuman'],
          'date': orderData['tanggal'],
          'totalAmount': double.parse(orderData['total_harga'].toString()),
          'status': orderData['status'], // Menambahkan status pesanan
        };
        orders.add(order);
      });

      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // Fungsi untuk mengirim permintaan HTTP POST untuk mengubah status pesanan
  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final response = await http.post(
      Uri.parse('${Config.url}/order/updateStatus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_detailpenjualan': orderId,
        'new_status': newStatus,
      }),
    );

    if (response.statusCode == 200) {
      // Berhasil mengubah status
      print('Order status updated successfully.');
      // Refresh daftar pesanan setelah perubahan berhasil
      setState(() {
        futureOrders = fetchOrders();
      });
    } else {
      // Gagal mengubah status
      throw Exception('Failed to update order status');
    }
  }

  // Fungsi untuk menampilkan popup berdasarkan status pesanan
  void _showStatusPopup(int orderId, String currentStatus) {
    String buttonLabel = '';
    String newStatus = '';
    if (currentStatus == 'processing') {
      buttonLabel = 'Shipped';
      newStatus = 'shipped';
    } else if (currentStatus == 'shipped') {
      buttonLabel = 'Delivered';
      newStatus = 'delivered';
    } else {
      return; // Jika status 'delivered', tidak menampilkan popup
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Order Status'),
          content: Text('Change status to $buttonLabel?'),
          actions: [
            TextButton(
              onPressed: () {
                updateOrderStatus(orderId, newStatus);
                Navigator.of(context).pop();
              },
              child: Text(buttonLabel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Orders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'View Orders',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: futureOrders,
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No orders found.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final order = snapshot.data![index];
                          return Card(
                            child: ListTile(
                              onTap: () {
                                _showStatusPopup(order['id'], order['status']);
                              },
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  order['id'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(order['customerName'].toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order['date'].toString()),
                                  SizedBox(height: 4),
                                  Text(
                                    'Status: ${order['status']}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                '\Rp. ${order['totalAmount'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: ViewOrdersScreen(),
    ));
