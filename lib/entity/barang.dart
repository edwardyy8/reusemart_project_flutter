import 'dart:convert';

class Barang {
  String? idBarang;
  String? idPenitip;
  int? idKategori;
  String? namaBarang;
  int? stokBarang;
  double? hargaBarang;
  String? garansiBarang;
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
    this.garansiBarang,
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
      idBarang: json["id_barang"],
      idPenitip: json["id_penitip"],
      idKategori: json["id_kategori"],
      namaBarang: json["nama_barang"],
      stokBarang: json["stok_barang"],
      hargaBarang: json["harga_barang"].toDouble(),
      garansiBarang: json["garansi"],
      statusBarang: json["status_barang"],
      deskripsiBarang: json["deskripsi"],
      tanggalMasuk: DateTime.parse(json["tanggal_masuk"]),
      beratBarang: json["berat_barang"].toDouble(),
      tanggalGaransi: DateTime.parse(json["tanggal_garansi"]),
      fotoBarang: json["foto_barang"],
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
      "garansi": garansiBarang,
      "status_barang": statusBarang,
      "deskripsi": deskripsiBarang,
      "tanggal_masuk": tanggalMasuk?.toIso8601String(),
      "berat_barang": beratBarang,
      "tanggal_garansi": tanggalGaransi?.toIso8601String(),
      "foto_barang": fotoBarang,
    };
  }
}