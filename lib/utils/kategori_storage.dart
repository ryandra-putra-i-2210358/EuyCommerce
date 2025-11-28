import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kategori_model.dart';

class KategoriStorage {
  static const String key = 'kategori_list';

  // Ambil kategori
  static Future<List<KategoriModel>> getKategori() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil LIST STRING, bukan string tunggal
    final List<String>? savedList = prefs.getStringList(key);

    if (savedList == null) return [];

    return savedList
        .map((e) => KategoriModel.fromJson(jsonDecode(e)))
        .toList();
  }

  // Tambah kategori
  static Future<void> addKategori(KategoriModel item) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> currentList = prefs.getStringList(key) ?? [];

    currentList.add(jsonEncode(item.toJson()));

    await prefs.setStringList(key, currentList);
  }

  // Hapus kategori
  static Future<void> deleteKategori(String name) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> currentList = prefs.getStringList(key) ?? [];

    currentList.removeWhere((e) {
      final data = KategoriModel.fromJson(jsonDecode(e));
      return data.name == name;
    });

    await prefs.setStringList(key, currentList);
  }
}
