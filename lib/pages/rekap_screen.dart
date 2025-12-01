import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'tambah_barang_screen.dart';
import 'profil_screen.dart';

import 'package:project_ecommerce/models/transaksi_model.dart';
import 'package:project_ecommerce/utils/rekap_storage.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  int _currentIndex = 1;

  List<Transaksi> data = [];
  List<Transaksi> dataFilter = [];

  String? selectedTanggal;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    data = await RekapStorage.loadTransaksi();
    dataFilter = data;
    setState(() {});
  }

  Future<void> hapusTransaksi(int index) async {
    data.removeAt(index);
    dataFilter = data;

    await RekapStorage.saveAllTransaksi(data);
    setState(() {});
  }

  // ================= FILTER TANGGAL =================
  void filterTanggal(String? tanggal) {
    selectedTanggal = tanggal;

    if (tanggal == null) {
      dataFilter = data;
    } else {
      dataFilter =
          data.where((trx) => trx.tanggal == tanggal).toList();
    }

    setState(() {});
  }

  // ================= HITUNG TOTAL KESELURUHAN =================
  int get totalKeseluruhan {
    int total = 0;
    for (var trx in dataFilter) {
      total += trx.total;
    }
    return total;
  }

  // ================= DATE PICKER =================
  Future<void> pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final tanggal =
          "${picked.day}-${picked.month}-${picked.year}";
      filterTanggal(tanggal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF173B63),
        title: const Text(
          "Rekap Transaksi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ================= HEADER FILTER + TOTAL =================
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: pilihTanggal,
                      icon: const Icon(Icons.date_range),
                      label: const Text("Filter Tanggal"),
                    ),
                    const SizedBox(width: 10),
                    if (selectedTanggal != null)
                      ElevatedButton.icon(
                        onPressed: () => filterTanggal(null),
                        icon: const Icon(Icons.close),
                        label: const Text("Reset"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Total Keseluruhan: Rp $totalKeseluruhan",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= LIST TRANSAKSI =================
          Expanded(
            child: dataFilter.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada transaksi",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: dataFilter.length,
                    itemBuilder: (context, index) {
                      final trx = dataFilter[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            "Transaksi #${trx.idTransaksi}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${trx.nama} • ${trx.tanggal}\nTotal: Rp ${trx.total}",
                          ),
                          isThreeLine: true,

                          // ================= DETAIL =================
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                    "Detail Transaksi #${trx.idTransaksi}"),
                                content: SizedBox(
                                  width: 350,
                                  height: 300,
                                  child: ListView(
                                    children: [
                                      Text("Nama: ${trx.nama}"),
                                      Text("Email: ${trx.email}"),
                                      Text("No HP: ${trx.nohp}"),
                                      Text("Alamat: ${trx.alamat}"),
                                      const Divider(height: 20),
                                      const Text(
                                        "Daftar Barang:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ...trx.items.map(
                                        (item) => ListTile(
                                          title:
                                              Text(item.namaBarang),
                                          subtitle:
                                              Text("Qty: ${item.qty}"),
                                          trailing: Text(
                                              "Rp ${item.harga}"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Tutup"),
                                    onPressed: () =>
                                        Navigator.pop(context),
                                  )
                                ],
                              ),
                            );
                          },

                          // ================= HAPUS =================
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title:
                                      const Text("Hapus Transaksi"),
                                  content: const Text(
                                      "Yakin ingin menghapus transaksi ini?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Batal"),
                                      onPressed: () =>
                                          Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text(
                                        "Hapus",
                                        style:
                                            TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        hapusTransaksi(index);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      bottomNavigationBar: _bottomNav(),
    );
  }

  // ================= BOTTOM NAV =================
  BottomNavigationBar _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: const Color(0xFF173B63),
      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        if (index == _currentIndex) return;

        Widget page;
        switch (index) {
          case 0:
            page = const DashboardScreen();
            break;
          case 1:
            page = const RekapScreen();
            break;
          case 2:
            page = const TambahBarangScreen();
            break;
          case 3:
            page = const ProfilScreen();
            break;
          default:
            return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },

      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long), label: "Rekap"),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box), label: "Tambah"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}
