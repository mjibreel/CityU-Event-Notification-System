import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for saving image URL
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Upload the image to Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('user_images/${user.uid}.jpg');
        await storageRef.putFile(_image!);
        final imageUrl = await storageRef.getDownloadURL();

        // Save the imageUrl to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'imageUrl': imageUrl});

        setState(() {
          _imageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _loadUserImage() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _imageUrl = doc['imageUrl'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserImage(); // Load the user image when the profile page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageUrl != null && _imageUrl!.isNotEmpty
                ? Image.network(_imageUrl!,
                    height: 150, width: 150, fit: BoxFit.cover)
                : _image != null
                    ? Image.file(_image!,
                        height: 150, width: 150, fit: BoxFit.cover)
                    : const CircleAvatar(
                        radius: 75,
                        backgroundImage:
                            AssetImage('assets/profile_placeholder.png'),
                      ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Choose Image'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
