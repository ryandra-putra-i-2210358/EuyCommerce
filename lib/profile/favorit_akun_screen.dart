import 'package:flutter/material.dart';

class FavoritAkunScreen extends StatefulWidget {
  const FavoritAkunScreen({super.key});

  @override
  State<FavoritAkunScreen> createState() => _FavoritAkunScreenState();
}

class _FavoritAkunScreenState extends State<FavoritAkunScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: const Text(
          "Favorit",
          style: TextStyle(color: Colors.white),
          
        ),
        backgroundColor: const Color(0xFF173B63),
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      body: const Center(
        child: Text(
          "Fitur ini belum tersedia di aplikasi",
          
        ),
      ),
    );
  }
}