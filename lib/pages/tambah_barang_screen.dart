import 'package:flutter/material.dart';
import '../utils/kategori_storage.dart';
import 'dashboard_screen.dart';
import 'rekap_screen.dart';
import 'profil_screen.dart';

class TambahBarangScreen extends StatefulWidget {
  const TambahBarangScreen({super.key});

  @override
  State<TambahBarangScreen> createState() => _TambahBarangScreenState();
}

class _TambahBarangScreenState extends State<TambahBarangScreen> {
  List<String> kategoriList = [];
  int _currentIndex = 2;

  final namaController = TextEditingController();
  final hargaJualController = TextEditingController();
  final hargaBeliController = TextEditingController();
  final labaController = TextEditingController();
  final kategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  void loadKategori() async {
    kategoriList = await KategoriStorage.getKategori();
    setState(() {});
  }

  void reloadKategori() async {
    kategoriList = await KategoriStorage.getKategori();
    setState(() {});
  }

  // DIALOG HAPUS KATEGORI
  void openDeleteDialog() async {
    final list = await KategoriStorage.getKategori();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Kategori"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await KategoriStorage.deleteKategori(item);
                      Navigator.pop(context);
                      reloadKategori();
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Tambah Barang",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          children: [
            // Gambar placeholder
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 110,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 35),

            // ===== DROPDOWN + DELETE BUTTON =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text("Pilih Kategorii"),
                  value: kategoriController.text.isEmpty
                      ? null
                      : kategoriController.text,
                  isExpanded: true,
                  items: kategoriList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      kategoriController.text = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),


            _inputField("harga jual", hargaJualController, isNumber: true),
            const SizedBox(height: 15),

            _inputField("harga beli", hargaBeliController, isNumber: true),
            const SizedBox(height: 15),

            _inputField("laba", labaController, isNumber: true),
            const SizedBox(height: 30),

            // BUTTON TAMBAH
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF173B63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Barang berhasil ditambahkan"),
                    ),
                  );
                },
                child: const Text(
                  "Tambah ke daftar barang",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _bottomNav(),
    );
  }

  // WIDGET INPUT FIELD
  Widget _inputField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()));
        } else if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const RekapScreen()));
        } else if (index == 3) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ProfilScreen()));
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
