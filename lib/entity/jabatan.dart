import 'dart:convert';

class Jabatan {
  int? idJabatan;
  String? namaJabatan;

  Jabatan({
    this.idJabatan,
    this.namaJabatan,
  });

  factory Jabatan.fromRawJson(String str) => Jabatan.fromJson(json.decode(str));

  factory Jabatan.fromJson(Map<String, dynamic> json) {
    return Jabatan(
      idJabatan: (json['id_jabatan']as num).toInt(),
      namaJabatan: json['nama_jabatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jabatan': idJabatan,
      'nama_jabatan': namaJabatan,
    };
  }
}