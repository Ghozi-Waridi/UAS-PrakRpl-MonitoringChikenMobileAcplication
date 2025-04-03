class DataAyam {
  String? id;
  String kategori;
  String? tanggal = DateTime.now().toString();

  DataAyam({this.id, required this.kategori, this.tanggal = ""});

  DataAyam copyWith({String? id, String? kategori, String? tanggal}) {
    return DataAyam(
      id: id ?? this.id,
      kategori: kategori ?? this.kategori,
      tanggal: tanggal ?? this.tanggal,
    );
  }

  factory DataAyam.fromJson(Map<dynamic, dynamic> json, String id) {
    return DataAyam(
      id: id,
      kategori: json['kategori'],
      tanggal: json['tanggal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'kategori': kategori, 'tanggal': tanggal};
  }
}
