import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/models/barang_model.dart';
import 'package:project_ecommerce/pages/keranjang_screen.dart';
import 'package:project_ecommerce/utils/cart_storage.dart';


class DetailBarangScreen extends StatelessWidget {
  final BarangModel item;

  const DetailBarangScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        backgroundColor: const Color(0xFF173B63),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Detail Barang",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item.nama,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black),
              ),
              child: item.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(
                        File(item.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image, size: 120),
            ),

            const SizedBox(height: 30),

            _info("Harga Jual", item.hargaJual),
            _info("Harga Beli", item.hargaBeli),
            _info("Bahan Baku", item.bahanBaku),
            _info("Laba", item.laba),

            const Spacer(),

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
                  CartStorage.tambahBarang(item);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KeranjangScreen(),
                    ),
                  );
                },

                child: const Text(
                  "Tambah ke Keranjang",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          
          ],
        ),
      ),
    );
  }

  Widget _info(String label, Object? value, {bool isCurrency = false}) {
    String display;
    if (value == null) {
      display = "-";
    } else if (isCurrency && value is num) {
      display = "Rp ${value}";
    } else {
      display = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text("$label :")),
          Text(display, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
