class DataTelur {
  String? id;
  String? idAyam;
  int jumlah;
  String? tanggal;

  DataTelur({this.id, required this.idAyam, required this.jumlah,  this.tanggal});

  factory DataTelur.fromJson(Map<dynamic, dynamic> json, String id) {
    return DataTelur(
      id: id,
      idAyam: json['id_ayam'],
      jumlah: json['jumlah'],
      tanggal: json['tanggal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ayam': idAyam,
      'jumlah': jumlah,
      'tanggal': tanggal,
    };
  }
}
