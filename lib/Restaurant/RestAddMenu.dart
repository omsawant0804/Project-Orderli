import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:orderligui/Restaurant/RestMenu.dart';
// menu all operations in this file...

class MenuItem {
  final String itemName;
  final String description;
  final double price;
  final String imageUrl;

  MenuItem({
    required this.itemName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}



class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMenuItem(String restaurantId, MenuItem menuItem) async {
    try {
      await _firestore
          .collection('Restaurant')
          .doc(restaurantId)
          .collection('Menu')
          .add(menuItem.toMap());
      print("Menu item added successfully!");
    } catch (e) {
      print("Failed to add menu item: $e");
      throw e; // Rethrow the error for further handling if needed
    }
  }

  Future<void> deleteMenuItem(
      String restaurantId, String documentId, String imageUrl) async {
    try {
      // Delete the document from Firestore
      await _firestore
          .collection('Restaurant')
          .doc(restaurantId)
          .collection('Menu')
          .doc(documentId)
          .delete();

      // Delete the image file from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();

      print('Deleted item and its corresponding image.');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> updateMenuItem(String restaurantId, String documentId,
      MenuItem updatedMenuItem, File? newImageFile) async {
    try {
      // Update the document in Firestore
      await _firestore
          .collection('Restaurant')
          .doc(restaurantId)
          .collection('Menu')
          .doc(documentId)
          .update(updatedMenuItem.toMap());

      // Check if a new image is provided
      if (newImageFile != null) {
        // Delete the old image from Firebase Storage
        await FirebaseStorage.instance.refFromURL(updatedMenuItem.imageUrl).delete();

        // Upload the new image to Firebase Storage
        Reference storageReference =
        FirebaseStorage.instance.ref().child('menuimages/${DateTime.now()}.png');
        await storageReference.putFile(newImageFile);

        // Retrieve the download URL for the new image
        String newImageUrl = await storageReference.getDownloadURL();

        // Update the image URL in Firestore
        await _firestore
            .collection('Restaurant')
            .doc(restaurantId)
            .collection('Menu')
            .doc(documentId)
            .update({'imageUrl': newImageUrl});
      }

      print('Updated menu item.');
    } catch (e) {
      print('Error updating menu item: $e');
    }
  }
}

class AddMenuItemScreen extends StatefulWidget {
  @override
  _AddMenuItemScreenState createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late File _imageFile = File(''); // Initialize with an empty file path
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  // String restoId="restaurantId123";
  String restoId="";

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");

    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImage() async {
    try {
      if (_imageFile == null || !_imageFile.existsSync()) {
        throw Exception("No image selected");
      }

      // Create a reference to the Firebase Storage location under 'menuimages' folder
      Reference storageReference = FirebaseStorage.instance.ref().child('menuimages/${DateTime.now()}.png');

      // Upload the file to Firebase Storage
      await storageReference.putFile(_imageFile);

      // Retrieve the download URL for the uploaded image
      return await storageReference.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      throw e; // Rethrow the error for further handling if needed
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restoId=user!.uid.toString();
    print(restoId);
  }

  Widget _buildImageWidget() {
    if (_imageFile.path.isNotEmpty) {
      return Image.file(
        _imageFile,
        height: 200,
      );
    } else {
      return Container(); // Return an empty container if no image is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(left: 0), // Adjust the left padding as needed
            child: Text(
              'Add dish',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF040404),
                fontSize: 20,
              ),
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 10), // Adjust the left padding as needed
            child: IconButton(
              color: Color(0xFF040404),
              iconSize: 25,
              onPressed: () {
              Navigator.pop(context);
              },
              icon: const Icon(Iconsax.close_circle,
              size: 30,
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Divider(
              height: 20,
              color: Color(0xFFEFEBEB),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageWidget(),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEF6129), // Set background color
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image, color: Colors.white), // Image upload icon
                            SizedBox(width: 8), // Adjust spacing between icon and text
                            Text(
                              'Select Menu Image',
                              style: TextStyle(color: Colors.white), // Set text color
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _itemNameController,
                        decoration: InputDecoration(
                          labelText: 'Enter Menu Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // Add black border
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Enter Menu Description',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // Add black border
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Enter Price',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black), // Add black border
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              String itemName = _itemNameController.text;
                              String description = _descriptionController.text;
                              double price = double.tryParse(_priceController.text) ?? 0.0;
        
                              if (itemName.isNotEmpty && description.isNotEmpty && price > 0) {
                                String imageUrl = await _uploadImage();
                                MenuItem menuItem = MenuItem(itemName: itemName, description: description, price: price, imageUrl: imageUrl);
                                _firestoreService.addMenuItem(restoId, menuItem); // Replace 'restaurantId123' with the actual ID of the restaurant
                                _itemNameController.clear();
                                _descriptionController.clear();
                                _priceController.clear();
                                setState(() {
                                  _imageFile = File(''); // Reset image file after upload
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Please enter valid input for all fields.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              print("Error adding menu item: $e");
                              // Handle the error, e.g., show an error dialog
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEF6129), // Set background color
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white), // Image upload icon
                              SizedBox(width: 8), // Adjust spacing between icon and text
                              Text(
                                'Add Menu Item',
                                style: TextStyle(color: Colors.white), // Set text color
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}