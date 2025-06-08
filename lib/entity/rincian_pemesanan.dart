import 'dart:convert';
import 'barang.dart';

class RincianPemesanan {
  int? idRincianPemesanan;
  String? idPemesanan;
  String? idBarang;
  double? hargaBarang;
  double? komisiHunter;
  double? komisiReusemart;
  double? bonusPenitip;
  int? rating;
  Barang? barang;

  RincianPemesanan({
    this.idRincianPemesanan,
    this.idPemesanan,
    this.idBarang,
    this.hargaBarang,
    this.komisiHunter,
    this.komisiReusemart,
    this.bonusPenitip,
    this.rating,
    this.barang,
  });

  factory RincianPemesanan.fromRawJson(String str) => RincianPemesanan.fromJson(json.decode(str));
  factory RincianPemesanan.fromJson(Map<String, dynamic> json) {
    return RincianPemesanan(
      idRincianPemesanan: (json['id_rincian_pemesanan'] as num?)?.toInt(),
      idPemesanan: json['id_pemesanan'] as String?,
      idBarang: json['id_barang'] as String?,
      hargaBarang: (json['harga_barang'] as num?)?.toDouble(),
      komisiHunter: (json['komisi_hunter'] as num?)?.toDouble(),
      komisiReusemart: (json['komisi_reusemart'] as num?)?.toDouble(),
      bonusPenitip: (json['bonus_penitip'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toInt(),
      barang: json['barang'] != null ? Barang.fromJson(json['barang']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_rincian_pemesanan': idRincianPemesanan,
      'id_pemesanan': idPemesanan,
      'id_barang': idBarang,
      'harga_barang': hargaBarang,
      'komisi_hunter': komisiHunter,
      'komisi_reusemart': komisiReusemart,
      'bonus_penitip': bonusPenitip,
      'rating': rating,
      'barang': barang?.toJson(),
    };
  }
}
