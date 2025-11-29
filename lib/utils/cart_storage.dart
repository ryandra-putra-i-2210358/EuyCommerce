import 'package:project_ecommerce/models/barang_model.dart';

class CartStorage {
  static List<Map<String, dynamic>> keranjang = [];

  static tambahBarang(BarangModel barang) {
    int index = keranjang.indexWhere((e) => e["barang"].nama == barang.nama);

    if (index == -1) {
      keranjang.add({
        "barang": barang,
        "jumlah": 1,
      });
    } else {
      keranjang[index]["jumlah"]++;
    }
  }

  static tambahQty(int index) {
    keranjang[index]["jumlah"]++;
  }

  static kurangQty(int index) {
    if (keranjang[index]["jumlah"] > 1) {
      keranjang[index]["jumlah"]--;
    }
  }

  // Hapus 1 item keranjang
  static void hapusItem(int index) {
    keranjang.removeAt(index);
  }

  // Hitung total harga
  static int totalHarga() {
    int total = 0;
    for (var item in keranjang) {
      final barang = item["barang"] as BarangModel;
      final jumlah = item["jumlah"] as int;

      total += barang.hargaJual * jumlah;
    }
    return total;
  }
}
