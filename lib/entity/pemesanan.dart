import 'dart:convert';
import 'rincian_pemesanan.dart';
import 'alamat.dart';

class Pemesanan {
  String? idPemesanan;
  int? idPembeli;
  String? idKurir;
  String? idGudang;
  double? totalHarga;
  String? metodePengiriman;
  DateTime? tanggalPemesanan;
  DateTime? tanggalPengiriman;
  DateTime? jadwalPengambilan;
  DateTime? tanggalDiterima;
  String? fotoBukti;
  DateTime? tanggalPelunasan;
  String? statusPembayaran;
  String? statusPengiriman;
  DateTime? batasPengambilan;
  int? poinDigunakan;
  int? poinDidapatkan;
  double? ongkos;
  int? idAlamat;
  List<RincianPemesanan>? rincianPemesanan;
  Alamat? alamat;

  Pemesanan({
    this.idPemesanan,
    this.idPembeli,
    this.idKurir,
    this.idGudang,
    this.totalHarga,
    this.metodePengiriman,
    this.tanggalPemesanan,
    this.tanggalPengiriman,
    this.jadwalPengambilan,
    this.tanggalDiterima,
    this.fotoBukti,
    this.tanggalPelunasan,
    this.statusPengiriman,
    this.batasPengambilan,
    this.poinDigunakan,
    this.poinDidapatkan,
    this.ongkos,
    this.idAlamat,
    this.rincianPemesanan,
    this.alamat,
  });

  factory Pemesanan.fromRawJson(String str) => Pemesanan.fromJson(json.decode(str));
  factory Pemesanan.fromJson(Map<String, dynamic> json) {
    return Pemesanan(
      idPemesanan: json['id_pemesanan'] as String?,
      idPembeli: json['id_pembeli'] != null
          ? (int.tryParse(json['id_pembeli'].toString()) ?? 0)
          : null,
      idKurir: json['id_kurir'] as String?,
      idGudang: json['id_gudang'] as String?,
      totalHarga: json['total_harga'] != null
          ? double.tryParse(json['total_harga'].toString())
          : null,
      metodePengiriman: json['metode_pengiriman'] as String?,
      tanggalPemesanan: json['tanggal_pemesanan'] != null
          ? DateTime.tryParse(json['tanggal_pemesanan'] as String)
          : null,
      tanggalPengiriman: json['tanggal_pengiriman'] != null
          ? DateTime.tryParse(json['tanggal_pengiriman'] as String)
          : null,
      jadwalPengambilan: json['jadwal_pengambilan'] != null
          ? DateTime.tryParse(json['jadwal_pengambilan'] as String)
          : null,
      tanggalDiterima: json['tanggal_diterima'] != null
          ? DateTime.tryParse(json['tanggal_diterima'] as String)
          : null,
      fotoBukti: json['foto_bukti'] as String?,
      tanggalPelunasan: json['tanggal_pelunasan'] != null
          ? DateTime.tryParse(json['tanggal_pelunasan'] as String)
          : null,      
      statusPengiriman: json['status_pengiriman'] as String?,
      batasPengambilan: json['batas_pengambilan'] != null
          ? DateTime.tryParse(json['batas_pengambilan'] as String)
          : null,
      poinDigunakan: json['poin_digunakan'] != null
          ? (int.tryParse(json['poin_digunakan'].toString()) ?? 0)
          : null,
      poinDidapatkan: json['poin_didapatkan'] != null
          ? (int.tryParse(json['poin_didapatkan'].toString()) ?? 0)
          : null,
      ongkos: json['ongkos'] != null
          ? double.tryParse(json['ongkos'].toString())
          : null,
      idAlamat: json['id_alamat'] != null
          ? (int.tryParse(json['id_alamat'].toString()) ?? 0)
          : null,
      rincianPemesanan: (json['rincian_pemesanan'] as List?)
          ?.map((item) => RincianPemesanan.fromJson(item))
          .toList(),
      alamat: json['alamat'] != null ? Alamat.fromJson(json['alamat']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pemesanan': idPemesanan,
      'id_pembeli': idPembeli,
      'id_kurir': idKurir,
      'id_gudang': idGudang,
      'total_harga': totalHarga,
      'metode_pengiriman': metodePengiriman,
      'tanggal_pemesanan': tanggalPemesanan?.toIso8601String(),
      'tanggal_pengiriman': tanggalPengiriman?.toIso8601String(),
      'jadwal_pengambilan': jadwalPengambilan?.toIso8601String(),
      'tanggal_diterima': tanggalDiterima?.toIso8601String(),
      'foto_bukti': fotoBukti,
      'tanggal_pelunasan': tanggalPelunasan?.toIso8601String(),
      'status_pengiriman': statusPengiriman,
      'batas_pengambilan': batasPengambilan?.toIso8601String(),
      'poin_digunakan': poinDigunakan,
      'poin_didapatkan': poinDidapatkan,
      'ongkos': ongkos,
      'id_alamat': idAlamat,
      'rincian_pemesanan': rincianPemesanan?.map((item) => item.toJson()).toList(),
      'alamat': alamat?.toJson(),
    };
  }
}




