// import 'package:flutter/material.dart';

// class AddOrderScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Order'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Add Order',
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Customer Name',
//                   labelStyle: TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey[900],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide(
//                       color: Colors.blueAccent,
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Order Date',
//                   labelStyle: TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey[900],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide(
//                       color: Colors.blueAccent,
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Total Amount',
//                   labelStyle: TextStyle(color: Colors.grey),
//                   filled: true,
//                   fillColor: Colors.grey[900],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     borderSide: BorderSide(
//                       color: Colors.blueAccent,
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add order logic here
//                   Navigator.pop(context);
//                 },
//                 child: Text('Add Order'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
