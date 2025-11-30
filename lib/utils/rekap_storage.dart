import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaksi_model.dart';

class RekapStorage {
  static const key = "rekap_transaksi";

  // simpan 1 transaksi
  static Future<void> saveTransaksi(Transaksi trx) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> current =
        prefs.getStringList(key) ?? [];

    current.add(jsonEncode(trx.toJson()));

    await prefs.setStringList(key, current);
  }

  // simpan seluruh list transaksi (untuk delete)
  static Future<void> saveAllTransaksi(List<Transaksi> list) async {
    final prefs = await SharedPreferences.getInstance();

    final data = list.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(key, data);
  }

  // load semua transaksi
  static Future<List<Transaksi>> loadTransaksi() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> raw = prefs.getStringList(key) ?? [];

    return raw
        .map((e) => Transaksi.fromJson(jsonDecode(e)))
        .toList();
  }
}
