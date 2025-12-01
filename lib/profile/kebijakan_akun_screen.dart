import 'package:flutter/material.dart';

class KebijakanAkunScreen extends StatefulWidget {
  const KebijakanAkunScreen({super.key});

  @override
  State<KebijakanAkunScreen> createState() => _KebijakanAkunScreenState();
}

class _KebijakanAkunScreenState extends State<KebijakanAkunScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: const Text(
          "Kebijakan Akun",
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