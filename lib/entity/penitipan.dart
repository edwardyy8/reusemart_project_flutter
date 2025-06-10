import 'dart:convert';
import 'rincian_penitipan.dart';

class Penitipan {
  String? idPenitipan;
  String? idPenitip;
  String? idQc;
  String? idHunter;
  DateTime? tanggalMasuk;
  List<Rincian_Penitipan>? rincianPenitipan;

  Penitipan({
    this.idPenitipan,
    this.idPenitip,
    this.idQc,
    this.idHunter,
    this.tanggalMasuk,
    this.rincianPenitipan,
  });

  factory Penitipan.fromRawJson(String str) => Penitipan.fromJson(json.decode(str));
  factory Penitipan.fromJson(Map<String, dynamic> json) {
    return Penitipan(
      idPenitipan: json['id_penitipan'] as String?,
      idPenitip: json['id_penitip'] as String?,
      idQc: json['id_qc'] as String?,
      idHunter: json['id_hunter'] as String?,
      tanggalMasuk: json['tanggal_masuk'] != null
          ? DateTime.tryParse(json['tanggal_masuk'] as String)
          : null,
      rincianPenitipan: (json['rincian_penitipan'] as List<dynamic>?)
          ?.map((item) => Rincian_Penitipan.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_penitipan': idPenitipan,
      'id_penitip': idPenitip,
      'id_qc': idQc,
      'id_hunter': idHunter,
      'tanggal_masuk': tanggalMasuk?.toIso8601String(),
      'rincian_penitipan': rincianPenitipan?.map((item) => item.toJson()).toList(),
    };
  }
}