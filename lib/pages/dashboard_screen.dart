import 'package:flutter/material.dart';
import 'package:project_ecommerce/pages/kategori_screen.dart';
import 'package:project_ecommerce/pages/profil_screen.dart';
import 'package:project_ecommerce/pages/rekap_screen.dart';
import 'package:project_ecommerce/pages/tambah_barang_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "LIMBAH KITA",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ===== SEARCH BAR =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "cari barang",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== GRID MENU =====
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: const [
                  DashboardItem(icon: Icons.add, title: "Transaksi"),
                  DashboardItem(icon: Icons.image, title: "Keset"),
                  DashboardItem(icon: Icons.image, title: "Dompet"),
                  DashboardItem(icon: Icons.image, title: "Tas"),
                  DashboardItem(icon: Icons.image, title: "Baju"),
                  DashboardItem(icon: Icons.image, title: "Celana"),
                ],
              ),
            ),
          ],
        ),
      ),

      // ===== FLOATING BUTTON =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF173B63),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KategoriScreen()),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),

      // ===== BOTTOM NAVIGATION =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF173B63),
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          if (index == _currentIndex) return; // Hindari double reload

          setState(() => _currentIndex = index);

          if (index == 0) {
            // Dashboard tetap di halaman ini
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RekapScreen()),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Rekapitulasi"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box), label: "Tambah Barang"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

// ===== WIDGET GRID ITEM =====
class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const DashboardItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 40),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
