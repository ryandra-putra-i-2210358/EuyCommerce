class BarangModel {
  final String nama;
  final int hargaJual;
  final int hargaBeli;
  final int laba;
  final String kategori;
  final String? imagePath;

  BarangModel({
    required this.nama,
    required this.hargaJual,
    required this.hargaBeli,
    required this.laba,
    required this.kategori,
    this.imagePath,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      nama: json['nama'],
      hargaJual: json['hargaJual'],
      hargaBeli: json['hargaBeli'],
      laba: json['laba'],
      kategori: json['kategori'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "hargaJual": hargaJual,
      "hargaBeli": hargaBeli,
      "laba": laba,
      "kategori": kategori,
      "imagePath": imagePath,
    };
  }
}
