import 'dart:convert';

class Kategori {
  int? idKategori;
  String? namaKategori;

  Kategori({
    this.idKategori,
    this.namaKategori,
  });

  factory Kategori.fromRawJson(String str) => Kategori.fromJson(json.decode(str));

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      idKategori: json['id_kategori'] != null
          ? int.tryParse(json['id_kategori'].toString())
          : null,
      namaKategori: json['nama_kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'nama_kategori': namaKategori,
    };
  }
}