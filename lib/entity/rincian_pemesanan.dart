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
      idRincianPemesanan: json['id_rincian_pemesanan'] != null
          ? (int.tryParse(json['id_rincian_pemesanan'].toString()) ?? 0)
          : null,
      idPemesanan: json['id_pemesanan'] as String?,
      idBarang: json['id_barang'] as String?,
      hargaBarang: json['harga_barang'] != null
          ? (double.tryParse(json['harga_barang'].toString()) ?? 0.0)
          : null,
      komisiHunter: json['komisi_hunter'] != null
          ? (double.tryParse(json['komisi_hunter'].toString()) ?? 0.0)
          : null,
      komisiReusemart: json['komisi_reusemart'] != null
          ? (double.tryParse(json['komisi_reusemart'].toString()) ?? 0.0)
          : null,
      bonusPenitip: json['bonus_penitip'] != null
          ? (double.tryParse(json['bonus_penitip'].toString()) ?? 0.0)
          : null,
      rating: json['rating'] != null
          ? (int.tryParse(json['rating'].toString()) ?? 0)
          : null,
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
