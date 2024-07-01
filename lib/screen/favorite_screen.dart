// FavoriteScreen.dart
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Map<String, String>> favoriteItems = [
    {
      'title': 'Cocktail',
      'description': 'Cosmopolitan.',
      'image': '',
    },
    {
      'title': 'Mocktail',
      'description': 'Hurricane.',
      'image': '',
    },
    {
      'title': 'Juice',
      'description': 'Mango Lemonde.',
      'image': '',
    },
    // Tambahkan item favorit lainnya di sini...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Mengatur jumlah item per baris
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 3, // Mengatur rasio aspek item
          ),
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: Image.network(
                      favoriteItems[index]['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      favoriteItems[index]['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      favoriteItems[index]['description']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
