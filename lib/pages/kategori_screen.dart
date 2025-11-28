import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/kategori_model.dart';
import '../utils/kategori_storage.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final namaKategoriController = TextEditingController();

  File? pickedImage;
  List<KategoriModel> kategoriList = [];

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  // Load data kategori dari penyimpanan
  void loadKategori() async {
    kategoriList = await KategoriStorage.getKategori();
    setState(() {});
  }

  // Pilih foto dari gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        pickedImage = File(file.path);
      });
    }
  }

  // Hapus kategori
  void deleteKategori(String name) async {
    await KategoriStorage.deleteKategori(name);
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
            // FOTO KATEGORI
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2),
                  image: pickedImage != null
                      ? DecorationImage(
                          image: FileImage(pickedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: pickedImage == null
                    ? const Icon(
                        Icons.image_outlined,
                        size: 110,
                        color: Colors.black87,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 35),

            // Input nama kategori
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: TextField(
                controller: namaKategoriController,
                decoration: const InputDecoration(
                  hintText: "Kategori",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol tambah
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
                  final name = namaKategoriController.text.trim();
                  if (name.isEmpty) return;

                  await KategoriStorage.addKategori(
                    KategoriModel(
                      name: name,
                      image: pickedImage?.path,
                    ),
                  );

                  namaKategoriController.clear();
                  pickedImage = null;
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

            const Text(
              "Daftar Kategori",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // LIST KATEGORI
            ...kategoriList.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black54, width: 1.3),
                ),
                child: Row(
                  children: [
                    // FOTO
                    if (item.image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(item.image!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const Icon(Icons.image_outlined, size: 45),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Text(item.name, style: const TextStyle(fontSize: 16)),
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteKategori(item.name),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
