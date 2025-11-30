import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/models/barang_model.dart';
import 'package:project_ecommerce/utils/cart_storage.dart';
import 'package:project_ecommerce/pages/checkout_screen.dart';
import 'package:project_ecommerce/pages/dashboard_screen.dart';
class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  @override
  Widget build(BuildContext context) {
    final keranjang = CartStorage.keranjang;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Keranjang", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: keranjang.length,
                itemBuilder: (context, i) {
                  final barang = keranjang[i]["barang"] as BarangModel;
                  final jumlah = keranjang[i]["jumlah"] as int;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FOTO PRODUK
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: barang.imagePath != null
                              ? Image.file(
                                  File(barang.imagePath!),
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 160,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 80),
                                ),
                        ),

                        const SizedBox(height: 12),

                        // NAMA + HAPUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              barang.nama,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                CartStorage.hapusItem(i);
                                setState(() {});
                              },
                              child: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // TOTAL ITEM × HARGA
                        Text(
                          "Rp ${barang.hargaJual * jumlah}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Bahan Baku : ${barang.bahanBaku}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // TOMBOL JUMLAH
                        Row(
                          children: [
                            // BUTTON +
                            GestureDetector(
                              onTap: () {
                                CartStorage.tambahQty(i);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF173B63),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                            ),

                            // Jumlah
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "$jumlah",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),

                            // BUTTON -
                            GestureDetector(
                              onTap: () {
                                CartStorage.kurangQty(i);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF173B63),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.remove, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // TOTAL HARGA DI BAWAH
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Total: Rp ${CartStorage.totalHarga()}",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // TOMBOL CHECKOUT
            Row(
              children: [
                // Tombol Dashboard (kiri)
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 220, 220, 33), // warna bebas
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            "Tambah",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Tombol Checkout (kanan)
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF173B63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Check Out",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
