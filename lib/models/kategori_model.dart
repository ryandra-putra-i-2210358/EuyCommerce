class KategoriModel {
  final String name;
  final String? image;

  KategoriModel({required this.name, this.image});

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
    };
  }
}
