class TransaksiDetail {
  final String idBarang;  // ← ubah jadi String
  final String namaBarang;
  final int harga;
  final int qty;

  TransaksiDetail({
    required this.idBarang,
    required this.namaBarang,
    required this.harga,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
        "id_barang": idBarang,
        "nama_barang": namaBarang,
        "harga": harga,
        "qty": qty,
      };

  factory TransaksiDetail.fromJson(Map<String, dynamic> json) {
    return TransaksiDetail(
      idBarang: json["id_barang"],
      namaBarang: json["nama_barang"],
      harga: json["harga"],
      qty: json["qty"],
    );
  }
}
