import 'package:flutter/material.dart';
import 'package:project_ecommerce/pages/dashboard_screen.dart';
import 'package:project_ecommerce/models/riwayat_model.dart';
import 'package:project_ecommerce/utils/riwayat_storage.dart';

class SuccessPaymentScreen extends StatelessWidget {
  final String metode;
  final int totalBayar;

  const SuccessPaymentScreen({
    super.key,
    required this.metode,
    required this.totalBayar,
  });

  Future<void> _simpanRiwayat() async {
    final data = RiwayatModel(
      metode: metode,
      totalBayar: totalBayar,
      tanggal: DateTime.now().toString().substring(0, 16),
    );

    await RiwayatStorage.tambahRiwayat(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: FutureBuilder(
        future: _simpanRiwayat(), // Simpan otomatis saat layar dibuka
        builder: (context, snapshot) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 110),
                  const SizedBox(height: 20),
                  const Text("Pembayaran Berhasil!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Metode: $metode", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Total: Rp $totalBayar",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  const SizedBox(height: 35),

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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DashboardScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Kembali ke Home",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
