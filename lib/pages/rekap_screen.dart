import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'tambah_barang_screen.dart';
import 'profil_screen.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Rekapitulasi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF173B63),
        iconTheme: const IconThemeData(color: Colors.white),
        // ❗Aktifkan tombol back "<"
        automaticallyImplyLeading: true,
      ),

      body: const Center(
        child: Text(
          "Data Rekapitulasi",
          style: TextStyle(fontSize: 18),
        ),
      ),

      bottomNavigationBar: _bottomNav(),
    );
  }

  BottomNavigationBar _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: const Color(0xFF173B63),
      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        if (index == _currentIndex) return;

        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBarangScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilScreen()),
          );
        }
      },

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Rekap"),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Tambah"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}
