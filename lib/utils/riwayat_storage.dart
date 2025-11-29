import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_ecommerce/models/riwayat_model.dart';

class RiwayatStorage {
  static const String _key = "riwayat_pembayaran";

  /// Tambah 1 riwayat (menyimpan ulang list setelah menambah)
  static Future<void> tambahRiwayat(RiwayatModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.add(jsonEncode(data.toJson()));
    await prefs.setStringList(_key, list);
  }

  /// Ambil semua riwayat sebagai List<RiwayatModel>
  static Future<List<RiwayatModel>> getRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((e) => RiwayatModel.fromJson(jsonDecode(e))).toList();
  }

  /// Simpan ulang seluruh list riwayat (dipanggil setelah ubah/delete)
  static Future<void> saveRiwayat(List<RiwayatModel> data) async {
    final prefs = await SharedPreferences.getInstance();
    final list = data.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, list);
  }

  /// Hapus riwayat berdasarkan index, lalu simpan perubahan
  static Future<void> hapusRiwayat(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await prefs.setStringList(_key, list);
    }
  }

  /// Hapus semua riwayat
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
