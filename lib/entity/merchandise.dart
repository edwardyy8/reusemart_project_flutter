import 'dart:convert';

class Merchandise {
  int? idMerchandise;
  String? namaMerchandise;
  int? stokMerchandise;
  int? poinMerchandise;
  String? fotoMerchandise;

  Merchandise({
    this.idMerchandise,
    this.namaMerchandise,
    this.stokMerchandise,
    this.poinMerchandise,
    this.fotoMerchandise,
  });

  factory Merchandise.fromRawJson(String str) => Merchandise.fromJson(json.decode(str));
  factory Merchandise.fromJson(Map<String, dynamic> json) {
    return Merchandise(
      idMerchandise: json['id_merchandise'],
      namaMerchandise: json['nama_merchandise'],
      stokMerchandise: json['stok_merchandise'],
      poinMerchandise: json['poin_merchandise'],
      fotoMerchandise: json['foto_merchandise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_merchandise': idMerchandise,
      'nama_merchandise': namaMerchandise,
      'stok_merchandise': stokMerchandise,
      'poin_merchandise': poinMerchandise,
      'foto_merchandise': fotoMerchandise,
    };
  }
}