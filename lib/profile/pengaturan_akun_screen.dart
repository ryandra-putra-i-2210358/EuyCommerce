import 'package:flutter/material.dart';

class PengaturanAkunScreen extends StatelessWidget {
  const PengaturanAkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: const Text(
          "Pengaturan Akun",
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
