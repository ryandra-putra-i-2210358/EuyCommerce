import 'package:shared_preferences/shared_preferences.dart';

class KategoriStorage {
  static const key = "kategori_list";

  // Ambil semua kategori
  static Future<List<String>> getKategori() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList(key) ?? [];
  }

  // Tambah kategori baru
  static Future<void> addKategori(String nama) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(key) ?? [];

    // Hindari duplikat
    if (!list.contains(nama)) {
      list.add(nama);
      await pref.setStringList(key, list);
    }
  }
  static Future<void> deleteKategori(String nama) async {
  final pref = await SharedPreferences.getInstance();
  final list = pref.getStringList(key) ?? [];

  list.remove(nama);

  await pref.setStringList(key, list);
}

}
