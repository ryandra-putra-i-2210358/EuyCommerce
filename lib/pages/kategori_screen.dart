import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/kategori_model.dart';
import '../utils/kategori_storage.dart';
import '../utils/file_helper.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final TextEditingController namaKategoriController = TextEditingController();

  File? pickedImage;
  List<KategoriModel> kategoriList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  Future<void> loadKategori() async {
    kategoriList = await KategoriStorage.getKategori();
    setState(() => isLoading = false);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1500,
      maxHeight: 1500,
      imageQuality: 85,
    );

    if (file == null) return;

    File img = File(file.path);

    try {
      img = await convertToJpeg(img);
    } catch (_) {}

    setState(() => pickedImage = img);
  }

  Future<void> addKategori() async {
    final name = namaKategoriController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama kategori tidak boleh kosong")),
      );
      return;
    }

    final exists = kategoriList.any(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori sudah ada")),
      );
      return;
    }

    await KategoriStorage.addKategori(
      KategoriModel(
        name: name,
        image: pickedImage?.path,
      ),
    );

    namaKategoriController.clear();
    pickedImage = null;

    await loadKategori();
  }

  Future<void> confirmDeleteKategori(String name, String? imagePath) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: Text("Apakah kamu yakin ingin menghapus kategori '$name'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteKategori(name, imagePath);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteKategori(String name, String? imagePath) async {
    await KategoriStorage.deleteKategori(name);

    if (imagePath != null && File(imagePath).existsSync()) {
      try {
        File(imagePath).deleteSync();
      } catch (_) {}
    }

    await loadKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        centerTitle: true,
        title: const Text(
          "Tambah Kategori",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO PREVIEW
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black87, width: 2),
                        image: pickedImage != null
                            ? DecorationImage(
                                image: FileImage(pickedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: pickedImage == null
                          ? const Icon(Icons.image_outlined,
                              size: 100, color: Colors.black54)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // INPUT KATEGORI
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black87, width: 1.4),
                    ),
                    child: TextField(
                      controller: namaKategoriController,
                      decoration: const InputDecoration(
                        hintText: "Nama kategori",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // TOMBOL TAMBAH
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF173B63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: addKategori,
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

                  const SizedBox(height: 35),

                  const Text(
                    "Daftar Kategori",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // LIST KATEGORI
                  ...kategoriList.map((item) {
                    final imageFile =
                        item.image != null ? File(item.image!) : null;
                    final imageExists =
                        imageFile != null && imageFile.existsSync();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black45, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageExists
                                ? Image.file(
                                    imageFile,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    size: 45,
                                    color: Colors.black45,
                                  ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => confirmDeleteKategori(
                              item.name,
                              item.image,
                            ),
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
