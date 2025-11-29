class RiwayatModel {
  final String metode;
  final int totalBayar;
  final String tanggal;

  RiwayatModel({
    required this.metode,
    required this.totalBayar,
    required this.tanggal,
  });

  Map<String, dynamic> toJson() {
    return {
      "metode": metode,
      "total": totalBayar,
      "tanggal": tanggal,
    };
  }

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      metode: json["metode"],
      totalBayar: json["total"],
      tanggal: json["tanggal"],
    );
  }
}
