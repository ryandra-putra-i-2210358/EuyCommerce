import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_ecommerce/models/barang_model.dart';
import 'package:project_ecommerce/pages/dashboard_screen.dart';
import 'package:project_ecommerce/models/transaksi_detail_model.dart';
import 'package:project_ecommerce/models/transaksi_model.dart';
import 'package:project_ecommerce/utils/rekap_storage.dart';
import 'package:project_ecommerce/pages/rekap_screen.dart';
import 'package:lottie/lottie.dart';


class InvoiceScreen extends StatelessWidget {
  final int totalHarga;
  final String customerNama;
  final String customerEmail;
  final String customerNohp;
  final String customerAlamat;
  final List items;
  

  const InvoiceScreen({
    super.key,
    required this.totalHarga,
    required this.items,
    required this.customerNama,
    required this.customerEmail,
    required this.customerNohp,
    required this.customerAlamat,
  });
  Future<void> simpanTransaksi(BuildContext context) async {
    await _generatePdf(context);

    final trx = Transaksi(
      idTransaksi: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: customerNama,
      email: customerEmail,
      nohp: customerNohp,
      alamat: customerAlamat,
      tanggal: DateTime.now(),
      total: totalHarga,
      items: items.map((item) {
        final barang = item["barang"];
        return TransaksiDetail(
          idBarang: barang.nama,
          namaBarang: barang.nama,
          harga: barang.hargaJual,
          qty: item["jumlah"],
        );
      }).toList(),
    );

    await RekapStorage.saveTransaksi(trx);
  }
  Future<void> simpanTransaksiTanpaPdf() async {
    final trx = Transaksi(
      idTransaksi: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: customerNama,
      email: customerEmail,
      nohp: customerNohp,
      alamat: customerAlamat,
      tanggal: DateTime.now(),
      total: totalHarga,
      items: items.map((item) {
        final barang = item["barang"];
        return TransaksiDetail(
          idBarang: barang.nama,
          namaBarang: barang.nama,
          harga: barang.hargaJual,
          qty: item["jumlah"],
        );
      }).toList(),
    );

    await RekapStorage.saveTransaksi(trx);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Invoice",
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF123A64),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text("Halo, $customerNama"),
            Text("Email: $customerEmail"),
            Text("No HP: $customerNohp"),
            Text("Alamat: $customerAlamat"),
            const SizedBox(height: 50),

            Text(
              "Total Pembayaran: Rp. $totalHarga\nSilakan transfer ke Bank BCA: 123412",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 80),

            // Tombol Download PDF
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123A64),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                    await simpanTransaksi(context);

                    if (!context.mounted) return;

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                  'assets/animation/success.json',
                                  width: 180,
                                  repeat: false,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Terimakasih Sudah Belanja Disini\nPesananmu Sedang Disiapkan...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    await Future.delayed(const Duration(seconds: 4));

                    if (!context.mounted) return;
                    Navigator.pop(context);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RekapScreen()),
                    );
                  },


                child: const Text(
                  "Download Invoice",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),

            const SizedBox(height: 20),
            

            // Kembali ke Dashboard
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF123A64),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                            
                onPressed: () async {
                  await simpanTransaksiTanpaPdf(); // ✅ DATA MASUK REKAP, TANPA PDF

                  if (!context.mounted) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 150,
                                child: Lottie.asset(
                                  "assets/animation/success.json",
                                  repeat: false,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Terimakasih Sudah Belanja Disini\nPesananmu Sedang Disiapkan...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  await Future.delayed(const Duration(seconds: 4));

                  if (!context.mounted) return;
                  Navigator.pop(context);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    (route) => false,
                  );
                },


                child: const Text(
                  "Kembali Ke Dashboard",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    // LOAD GAMBAR ITEM
    final List<pw.MemoryImage?> images = [];

    for (var item in items) {
      final barang = item["barang"] as BarangModel;

      if (barang.imagePath != null && barang.imagePath!.isNotEmpty) {
        final file = File(barang.imagePath!);

        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          images.add(pw.MemoryImage(bytes));
        } else {
          images.add(null);
        }
      } else {
        images.add(null);
      }
    }

    // ========= PDF PAGE =========
    pdf.addPage(
      pw.Page(
        build: (_) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // TITLE
              pw.Center(
                child: pw.Text(
                  "INVOICE PEMBELIAN",
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),

              // ========== CUSTOMER DETAIL ==========
              pw.Text(
                "DATA CUSTOMER",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text("Nama     : $customerNama"),
              pw.Text("Email    : $customerEmail"),
              pw.Text("No HP    : $customerNohp"),
              pw.Text("Alamat   : $customerAlamat"),
              pw.SizedBox(height: 20),

              // TITLE PRODUK
              pw.Text(
                "DETAIL PEMBELIAN",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // TABLE PRODUK
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(60),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FixedColumnWidth(50),
                  3: const pw.FixedColumnWidth(80),
                },
                children: [
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _headerCell("Foto"),
                      _headerCell("Produk"),
                      _headerCell("Qty", align: pw.TextAlign.center),
                      _headerCell("Subtotal", align: pw.TextAlign.center),
                    ],
                  ),

                  // Data rows
                  for (int i = 0; i < items.length; i++)
                    _buildRow(items[i], images[i]),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                "Total Pembayaran: Rp $totalHarga",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text("Silakan transfer ke Bank BCA: 1234567890"),
            ],
          ),
        ),
      ),
    );

    final bytes = await pdf.save();

    // SAVE ANDROID
    if (Platform.isAndroid) {
      final permission = await Permission.manageExternalStorage.request();

      if (!permission.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin penyimpanan ditolak")),
        );
        return;
      }

      final path =
          "/storage/emulated/0/Download/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invoice berhasil disimpan ke folder Download")),
      );
    }

    // SAVE iOS
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/invoice.pdf");

      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)]);
    }
  }

  // HEADER CELL
  pw.Widget _headerCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, textAlign: align),
    );
  }

  // ROW ITEM TABLE
  pw.TableRow _buildRow(Map<String, dynamic> item, pw.MemoryImage? image) {
    final barang = item["barang"] as BarangModel;
    final jumlah = item["jumlah"] as int;
    final subtotal = barang.hargaJual * jumlah;

    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: image != null
              ? pw.Image(image, width: 50, height: 50)
              : pw.Container(
                  width: 50,
                  height: 50,
                  color: PdfColors.grey300,
                  alignment: pw.Alignment.center,
                  child: pw.Text("No\nImage", textAlign: pw.TextAlign.center),
                ),
        ),

        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text("${barang.nama}\nRp ${barang.hargaJual}"),
        ),

        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text("$jumlah", textAlign: pw.TextAlign.center),
        ),

        pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text("Rp $subtotal", textAlign: pw.TextAlign.center),
        ),
      ],
    );
  }
}
