// import 'dart:io';

class BarangModel {
  final String nama;
  final int hargaJual;
  final int hargaBeli;
  final String bahanBaku;
  final int laba;
  final String kategori;
  final String? imagePath;

  BarangModel({
    required this.nama,
    required this.hargaJual,
    required this.hargaBeli,
    required this.bahanBaku,
    required this.laba,
    required this.kategori,
    this.imagePath,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      nama: json['nama'] ?? "",
      hargaJual: json['hargaJual'] ?? 0,
      hargaBeli: json['hargaBeli'] ?? 0,
      bahanBaku: json['bahanBaku'] ?? "",
      laba: json['laba'] ?? 0,
      kategori: json['kategori'] ?? "",
      imagePath: json['imagePath'], // bisa null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "hargaJual": hargaJual,
      "hargaBeli": hargaBeli,
      "bahanBaku": bahanBaku,
      "laba": laba,
      "kategori": kategori,
      "imagePath": imagePath,
    };
  }
}
