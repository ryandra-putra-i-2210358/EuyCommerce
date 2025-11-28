import 'package:project_ecommerce/models/barang_model.dart';
import 'package:project_ecommerce/utils/barang_storage.dart';
import 'package:project_ecommerce/pages/detail_barang_screen.dart';
import 'dart:io';
import 'package:flutter/material.dart';

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

      body:
          barangList.isEmpty
              ? const Center(child: Text("Belum ada barang"))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: barangList.length,
                itemBuilder: (context, index) {
                  final item = barangList[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailBarangScreen(item: item),
                          ),
                        );
                      },

                      leading: item.imagePath != null
                          ? Image.file(
                              File(item.imagePath!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image),

                      title: Text(item.nama),
                      subtitle: Text(
                        "Beli: ${item.hargaBeli} | Jual: ${item.hargaJual}",
                      ),
                      trailing: Text(
                        "Laba: ${item.laba}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );

                },
              ),
    );
  }
}
