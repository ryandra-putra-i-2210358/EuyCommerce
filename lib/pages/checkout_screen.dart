import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/utils/cart_storage.dart';
import 'package:project_ecommerce/models/barang_model.dart';
// import 'package:project_ecommerce/pages/invoice_screen.dart';
import 'package:project_ecommerce/pages/customer_form_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final keranjang = CartStorage.keranjang;
    final totalHarga = CartStorage.totalHarga();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // ===============================
            // LIST PRODUK DALAM KERANJANG
            // ===============================
            Expanded(
              child: ListView.builder(
                itemCount: keranjang.length,
                itemBuilder: (context, index) {
                  final barang = keranjang[index]["barang"] as BarangModel;
                  final jumlah = keranjang[index]["jumlah"] as int;

                  return ListTile(
                    leading: barang.imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(barang.imagePath!),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.image, size: 40),

                    title: Text(
                      barang.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      "$jumlah × Rp ${barang.hargaJual}",
                      style: const TextStyle(fontSize: 14),
                    ),

                    trailing: Text(
                      "Rp ${barang.hargaJual * jumlah}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // ===============================
            // TOTAL BAYAR
            // ===============================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Bayar:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp $totalHarga",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===============================
            // TOMBOL BAYAR
            // ===============================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF173B63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: () async {
                  // ============= SHOW LOADING =============
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: Color(0xFF173B63),
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                    ),
                  );

                  // Simulasi loading 2 detik
                  await Future.delayed(const Duration(seconds: 2));

                  Navigator.pop(context); // tutup loading

                  // ============= TO INVOICE SCREEN =============
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerFormScreen(
                        totalHarga: totalHarga,
                        items: keranjang,
                      ),
                    ),
                  );

                },

                child: const Text(
                  "Bayar Sekarang",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
