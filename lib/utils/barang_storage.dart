import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/barang_model.dart';

class BarangStorage {
  static const String key = "barang_list";

  /// Simpan gambar ke folder permanen aplikasi
  static Future<String> saveImagePermanently(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final newPath = p.join(directory.path, p.basename(filePath));

    final newImage = await File(filePath).copy(newPath);
    return newImage.path;
  }

  /// Ambil semua barang
  static Future<List<BarangModel>> getBarang() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return [];

    try {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => BarangModel.fromJson(e)).toList();
    } catch (e) {
      print("Error decode barang: $e");
      return [];
    }
  }

  /// Tambah barang baru
  static Future<void> addBarang(BarangModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getBarang();

    list.add(item);

    await prefs.setString(
      key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> deleteBarang(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getBarang();

    // filter barang yang namanya bukan yang ingin dihapus
    final updated = list.where((e) => e.nama != nama).toList();

    await prefs.setString(
      key,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }


  /// Ambil barang berdasarkan kategori
  static Future<List<BarangModel>> getBarangByKategori(String kategori) async {
    final list = await getBarang();
    return list.where((e) => e.kategori == kategori).toList();
  }
}
