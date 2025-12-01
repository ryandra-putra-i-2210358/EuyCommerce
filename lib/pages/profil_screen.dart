import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'rekap_screen.dart';
import 'tambah_barang_screen.dart';
import 'package:project_ecommerce/screens/login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF173B63),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER PROFIL =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF173B63),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.person, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Nama Pengguna",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "User@email.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= MENU AKUN =================
            _sectionTitle("Akun"),
            _menuItem(
              icon: Icons.settings,
              title: "Pengaturan Akun",
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.favorite,
              title: "Favorit Saya",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // ================= MENU INFORMASI =================
            _sectionTitle("Informasi"),
            _menuItem(
              icon: Icons.privacy_tip,
              title: "Kebijakan Layanan",
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.info,
              title: "Versi Aplikasi",
              trailing: const Text("V1.0.0"),
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // ================= MENU LOGOUT =================
            _sectionTitle("Keluar"),
            _menuItem(
              icon: Icons.logout,
              title: "Keluar",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Yakin ingin keluar?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // tutup dialog

                          // HAPUS SEMUA HALAMAN SEBELUMNYA
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text("Keluar"),
                      ),
                    ],
                  ),
                );
              },

            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: _bottomNav(),
    );
  }

  // ======== MENU KOMPONEN ========
  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black38),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // ======== BOTTOM NAVIGATION ========
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
        } 
        else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RekapScreen()),
          );
        } 
        else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBarangScreen()),
          );
        } 
        else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilScreen()),
          );
        }
      },



      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Rekapitulasi"),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Tambah Barang"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}
