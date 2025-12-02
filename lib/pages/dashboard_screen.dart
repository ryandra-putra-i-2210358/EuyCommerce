import 'dart:io';
import '../models/kategori_model.dart';
import '../utils/kategori_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/pages/kategori_screen.dart';
import 'package:project_ecommerce/pages/profil_screen.dart';
import 'package:project_ecommerce/pages/rekap_screen.dart';
import 'package:project_ecommerce/pages/tambah_barang_screen.dart';
import 'package:project_ecommerce/pages/barang_by_kategori_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  List<KategoriModel> kategoriList = [];
  List<KategoriModel> filteredList = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  void loadKategori() async {
    kategoriList = await KategoriStorage.getKategori();

    setState(() {
      filteredList = kategoriList; // awal: tampilkan semua
    });
  }

  void filterKategori(String query) {
    final hasil = kategoriList.where((item) {
      final nama = item.name.toLowerCase();
      final gambar = (item.image ?? "").toLowerCase();
      final q = query.toLowerCase();

      return nama.contains(q) || gambar.contains(q);
    }).toList();

    setState(() {
      filteredList = hasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
              child: TextField(
                controller: searchController,
                onChanged: filterKategori,
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "cari barang",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== GRID MENU =====
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(
                      child: Text(
                        "Silahkan Isi Kategori Terlebih Dahulu",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BarangByKategoriScreen(
                                  kategori: item.name,
                                ),
                              ),
                            );
                          },
                          child: DashboardItem(
                            title: item.name,
                            imagePath: item.image,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF173B63),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KategoriScreen()),
          );

          // refresh ketika kembali
          loadKategori();
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),

      bottomNavigationBar: BottomNavigationBar(
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
  final String title;
  final String? imagePath;

  const DashboardItem({super.key, required this.title, this.imagePath});

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
          child: (imagePath != null && File(imagePath!).existsSync())
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(imagePath!), fit: BoxFit.cover),
                )
              : const Icon(Icons.image_outlined, size: 40),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
