import 'dart:convert';
 
class Barang {
  String? idBarang;
  String? idPenitip;
  int? idKategori;
  String? namaBarang;
  int? stokBarang;
  double? hargaBarang;
  String? garansi;
  String? statusBarang;
  String? deskripsiBarang;
  DateTime? tanggalMasuk;
  double? beratBarang;
  DateTime? tanggalGaransi;
  String? fotoBarang;
 
  Barang({
    this.idBarang,
    this.idPenitip,
    this.idKategori,
    this.namaBarang,
    this.stokBarang,
    this.hargaBarang,
    this.garansi,
    this.statusBarang,
    this.deskripsiBarang,
    this.tanggalMasuk,
    this.beratBarang,
    this.tanggalGaransi,
    this.fotoBarang,
  });
 
  factory Barang.fromRawJson(String str) => Barang.fromJson(json.decode(str));
  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      idBarang: json["id_barang"] as String?,
      idPenitip: json["id_penitip"] as String?,
      idKategori: (json['id_kategori'] as num?)?.toInt(),
      namaBarang: json["nama_barang"] as String?,
      stokBarang: (json['stok_barang'] as num?)?.toInt(),
      hargaBarang: (json["harga_barang"] as num?)?.toDouble(),
      garansi: json["garansi"] as String?,
      statusBarang: json["status_barang"] as String?,
      deskripsiBarang: json["deskripsi"] as String?,
      tanggalMasuk: json['tanggal_masuk'] != null
          ? DateTime.tryParse(json['tanggal_masuk'] as String)
          : null,
      beratBarang: (json["berat_barang"] as num?)?.toDouble(),
      tanggalGaransi: json['tanggal_garansi'] != null
          ? DateTime.tryParse(json['tanggal_garansi'] as String)
          : null,
      fotoBarang: json["foto_barang"] as String?,
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      "id_barang": idBarang,
      "id_penitip": idPenitip,
      "id_kategori": idKategori,
      "nama_barang": namaBarang,
      "stok_barang": stokBarang,
      "harga_barang": hargaBarang,
      "garansi": garansi,
      "status_barang": statusBarang,
      "deskripsi": deskripsiBarang,
      "tanggal_masuk": tanggalMasuk?.toIso8601String(),
      "berat_barang": beratBarang,
      "tanggal_garansi": tanggalGaransi?.toIso8601String(),
      "foto_barang": fotoBarang,
    };
  }
}