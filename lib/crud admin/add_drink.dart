import 'dart:io';

import 'package:bar_app/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class AddDrinkScreen extends StatefulWidget {
  @override
  _AddDrinkScreenState createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends State<AddDrinkScreen> {
  File? _image;

  final TextEditingController _drinkNameController = TextEditingController();
  final TextEditingController _drinkDescriptionController =
      TextEditingController();
  final TextEditingController _drinkPriceController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categoryList = [
    'coctail',
    'moctail',
    'smoothies',
    'juice',
  ];

  @override
  void dispose() {
    _drinkNameController.dispose();
    _drinkDescriptionController.dispose();
    _drinkPriceController.dispose();
    super.dispose();
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.lightBlue,
        hintText: 'Choose Category',
        hintStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2.0,
          ),
        ),
      ),
      value: _selectedCategory,
      items: _categoryList.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Pilih Kategori';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Drink'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Drink',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                _buildDropdown(),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _drinkNameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Drink Name',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.lightBlue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _drinkDescriptionController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Drink Description',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.lightBlue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _drinkPriceController,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Drink Price',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.lightBlue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                _image != null
                    ? Image.file(
                        _image!,
                        height: 100,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _showImagePicker(context);
                        },
                        child: Text('Add Image'),
                      ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _addDrink();
                  },
                  child: Text('Save Drink'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addDrink() async {
    final String drinkName = _drinkNameController.text.trim();
    final String drinkDescription = _drinkDescriptionController.text.trim();
    final String drinkPrice = _drinkPriceController.text.trim();
    final String? selectedCategory = _selectedCategory;

    if (selectedCategory == null || _image == null) {
      // Handle case where category or image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and add an image')),
      );
      return;
    }

    int category;
    switch (selectedCategory) {
      case 'coctail':
        category = 1;
        break;
      case 'moctail':
        category = 2;
        break;
      case 'smoothies':
        category = 3;
        break;
      case 'juice':
        category = 4;
        break;
      default:
        category = 0;
    }

    try {
      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToFirebase();

      // Save drink details to database
      await _saveDrinkToDatabase(
          drinkName, drinkDescription, drinkPrice, category, imageUrl);

      // Clear input values after adding
      _drinkNameController.clear();
      _drinkDescriptionController.clear();
      _drinkPriceController.clear();
      setState(() {
        _selectedCategory = null;
        _image = null;
      });

      print('Drink added successfully');
    } catch (e) {
      print('Failed to add drink: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add drink')),
      );
    }
  }

  Future<String> _uploadImageToFirebase() async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('drink_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
      firebase_storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);

      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image to Firebase Storage: $e');
    }
  }

  Future<void> _saveDrinkToDatabase(String name, String description,
      String price, int category, String imageUrl) async {
    try {
      // Send HTTP request to your API endpoint to save drink details to database
      var url = Uri.parse('${Config.url}/add_drink');
      var response = await http.post(
        url,
        body: {
          'name': name,
          'description': description,
          'price': price,
          'category': category.toString(),
          'image_url':
              imageUrl, // Pass the Firebase Storage image URL to your API
        },
      );

      if (response.statusCode == 200) {
        print('Drink details saved to database');
      } else {
        throw Exception('Failed to save drink details to database');
      }
    } catch (e) {
      throw Exception('Failed to save drink details to database: $e');
    }
  }

  void _showImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
}
