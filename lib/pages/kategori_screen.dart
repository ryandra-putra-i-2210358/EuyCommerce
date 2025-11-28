import 'package:flutter/material.dart';
import 'package:project_ecommerce/utils/kategori_storage.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final namaKategoriController = TextEditingController();

  List<String> kategoriList = [];

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  void loadKategori() async {
    kategoriList = await KategoriStorage.getKategori();
    setState(() {});
  }

  void deleteKategori(String nama) async {
    await KategoriStorage.deleteKategori(nama);
    loadKategori();
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
          "Tambah Kategori",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            _inputField("Kategori", namaKategoriController),
            const SizedBox(height: 15),

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
                onPressed: () async {
                  final kategori = namaKategoriController.text.trim();
                  if (kategori.isEmpty) return;

                  await KategoriStorage.addKategori(kategori);
                  namaKategoriController.clear();
                  loadKategori();
                },
                child: const Text(
                  "Tambah ke daftar kategori",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===================== LIST KATEGORI =====================
            const Text(
              "Daftar Kategori",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...kategoriList.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black54, width: 1.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item, style: const TextStyle(fontSize: 16)),
                    
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        deleteKategori(item);
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // INPUT FIELD
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
}
