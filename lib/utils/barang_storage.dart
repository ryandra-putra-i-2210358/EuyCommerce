import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BarangItem {
  final String nama;
  final int hargaJual;
  final int hargaBeli;
  final int laba;
  final String kategori;
  final String? imagePath;

  BarangItem({
    required this.nama,
    required this.hargaJual,
    required this.hargaBeli,
    required this.laba,
    required this.kategori,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "hargaJual": hargaJual,
        "hargaBeli": hargaBeli,
        "laba": laba,
        "kategori": kategori,
        "imagePath": imagePath,
      };

  factory BarangItem.fromJson(Map<String, dynamic> json) {
    return BarangItem(
      nama: json["nama"],
      hargaJual: json["hargaJual"],
      hargaBeli: json["hargaBeli"],
      laba: json["laba"],
      kategori: json["kategori"],
      imagePath: json["imagePath"],
    );
  }
}

class BarangStorage {
  static const String key = "barang_list";

  static Future<List<BarangItem>> getBarang() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return [];

    List list = jsonDecode(data);
    return list.map((e) => BarangItem.fromJson(e)).toList();
  }

  static Future<void> addBarang(BarangItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getBarang();

    list.add(item);

    await prefs.setString(
      key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }
}
