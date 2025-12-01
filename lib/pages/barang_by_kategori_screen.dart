import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/models/barang_model.dart';
import 'package:project_ecommerce/utils/barang_storage.dart';
import 'package:project_ecommerce/pages/detail_barang_screen.dart';

class BarangByKategoriScreen extends StatefulWidget {
  final String kategori;

  const BarangByKategoriScreen({super.key, required this.kategori});

  @override
  State<BarangByKategoriScreen> createState() => _BarangByKategoriScreenState();
}

class _BarangByKategoriScreenState extends State<BarangByKategoriScreen> {
  List<BarangModel> barangList = [];

  @override
  void initState() {
    super.initState();
    loadBarang();
  }

  void loadBarang() async {
    barangList = await BarangStorage.getBarangByKategori(widget.kategori);
    setState(() {});
  }

  Future<void> deleteBarang(BarangModel item) async {
    // Konfirmasi sebelum hapus
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Barang?"),
        content: Text("Yakin ingin menghapus '${item.nama}' ?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await BarangStorage.deleteBarang(item.nama);

    // Hapus file foto kalau ada
    if (item.imagePath != null && File(item.imagePath!).existsSync()) {
      try {
        File(item.imagePath!).deleteSync();
      } catch (_) {}
    }

    loadBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        title: Text(
          widget.kategori,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: barangList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada barang",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: barangList.length,
              itemBuilder: (context, index) {
                final item = barangList[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      // GAMBAR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: (item.imagePath != null &&
                                File(item.imagePath!).existsSync())
                            ? Image.file(
                                File(item.imagePath!),
                                width: 65,
                                height: 65,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 65,
                                height: 65,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 32),
                              ),
                      ),

                      const SizedBox(width: 14),

                      // INFO BARANG
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailBarangScreen(item: item),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Harga Modal: ${item.hargaBeli}",
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                "Harga Jual: ${item.hargaJual}",
                                style: const TextStyle(fontSize: 13),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Bahan: ${item.bahanBaku}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // TOMBOL DELETE
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteBarang(item),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
