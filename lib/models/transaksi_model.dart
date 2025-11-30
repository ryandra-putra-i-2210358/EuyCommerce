import 'transaksi_detail_model.dart';

class Transaksi {
  final String idTransaksi;
  final String nama;
  final String email;
  final String nohp;
  final String alamat;
  final DateTime tanggal; // <-- cuma ini

  final int total;
  final List<TransaksiDetail> items;

  Transaksi({
    required this.idTransaksi,
    required this.nama,
    required this.email,
    required this.nohp,
    required this.alamat,
    required this.tanggal,
    required this.total,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        "id_transaksi": idTransaksi,
        "nama": nama,
        "email": email,
        "nohp": nohp,
        "alamat": alamat,
        "tanggal": tanggal.toIso8601String(),
        "total": total,
        "items": items.map((e) => e.toJson()).toList(),
      };

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idTransaksi: json["id_transaksi"],
      nama: json["nama"],
      email: json["email"],
      nohp: json["nohp"],
      alamat: json["alamat"],
      tanggal: DateTime.parse(json["tanggal"]),
      total: json["total"],
      items: (json["items"] as List)
          .map((e) => TransaksiDetail.fromJson(e))
          .toList(),
    );
  }
}
