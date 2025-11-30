import 'package:flutter/material.dart';

// Pages
import 'dashboard_screen.dart';
import 'tambah_barang_screen.dart';
import 'profil_screen.dart';

// Model & Storage
import 'package:project_ecommerce/models/riwayat_model.dart';
import 'package:project_ecommerce/utils/riwayat_storage.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  int _currentIndex = 1;
  List<RiwayatModel> riwayat = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    riwayat = await RiwayatStorage.getRiwayat();
    setState(() {});
  }

  Future<void> hapusRiwayat(int index) async {
    riwayat.removeAt(index);

    // WAJIB! Supaya data benar-benar hilang dari penyimpanan
    await RiwayatStorage.saveRiwayat(riwayat);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        title: const Text(
          "Rekapitulasi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: riwayat.isEmpty
          ? const Center(
              child: Text(
                "Belum ada riwayat pembayaran",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: riwayat.length,
              itemBuilder: (context, index) {
                final r = riwayat[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      "Metode: ${r.metode}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Tanggal: ${r.tanggal}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Rp ${r.totalBayar}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Tombol hapus
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Hapus Riwayat"),
                                content: const Text(
                                    "Apakah kamu yakin ingin menghapus riwayat ini?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Batal"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      hapusRiwayat(index);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: _bottomNav(),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION BAR
  // ============================================================
  BottomNavigationBar _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: const Color(0xFF173B63),
      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        if (index == _currentIndex) return;

        Widget page;
        switch (index) {
          case 0:
            page = const DashboardScreen();
            break;
          case 1:
            page = const RekapScreen();
            break;
          case 2:
            page = const TambahBarangScreen();
            break;
          case 3:
            page = const ProfilScreen();
            break;
          default:
            return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Rekapitulasi",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: "Tambah Barang",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }
}
