import 'dart:convert';
import 'penitipan.dart';
import 'barang.dart';

class Rincian_Penitipan {
  int? idRincianPenitipan; // Diubah ke int? sesuai database
  String? idPenitipan;
  String? idBarang;
  DateTime? tanggalAkhir;
  String? perpanjangan; // Diubah ke String? sesuai database
  DateTime? batasAkhir;
  String? statusPenitipan;
  Barang? barang;
  Penitipan? penitipan; // Field tambahan untuk data penitipan terkait

  Rincian_Penitipan({
    this.idRincianPenitipan,
    this.idPenitipan,
    this.idBarang,
    this.tanggalAkhir,
    this.perpanjangan,
    this.batasAkhir,
    this.statusPenitipan,
    this.barang,
    this.penitipan,
  });

  factory Rincian_Penitipan.fromRawJson(String str) => Rincian_Penitipan.fromJson(json.decode(str));
  factory Rincian_Penitipan.fromJson(Map<String, dynamic> json) {
    return Rincian_Penitipan(
      idRincianPenitipan: json['id_rincianpenitipan'] != null
          ? (int.tryParse(json['id_rincianpenitipan'].toString()) ?? 0)
          : null,
      idPenitipan: json['id_penitipan'] as String?,
      idBarang: json['id_barang'] as String?,
      tanggalAkhir: json['tanggal_akhir'] != null
          ? DateTime.tryParse(json['tanggal_akhir'] as String)
          : null,
      perpanjangan: json['perpanjangan'] as String?,
      batasAkhir: json['batas_akhir'] != null
          ? DateTime.tryParse(json['batas_akhir'] as String)
          : null,
      statusPenitipan: json['status_penitipan'] as String?,
      barang: json['barang'] != null ? Barang.fromJson(json['barang']) : null,
      penitipan: json['penitipan'] != null ? Penitipan.fromJson(json['penitipan']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_rincianpenitipan': idRincianPenitipan,
      'id_penitipan': idPenitipan,
      'id_barang': idBarang,
      'tanggal_akhir': tanggalAkhir?.toIso8601String(),
      'perpanjangan': perpanjangan,
      'batas_akhir': batasAkhir?.toIso8601String(),
      'status_penitipan': statusPenitipan,
      'barang': barang?.toJson(),
      'penitipan': penitipan?.toJson(),
    };
  }
}