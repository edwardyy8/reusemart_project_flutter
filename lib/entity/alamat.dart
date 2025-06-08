import 'dart:convert';

class Alamat {
  int? idAlamat;
  int? idPembeli;
  int? isDefault;
  String? namaAlamat;
  String? labelAlamat;
  String? namaPenerima;
  String? noHp;

  Alamat({
    this.idAlamat,
    this.idPembeli,
    this.isDefault,
    this.namaAlamat,
    this.labelAlamat,
    this.namaPenerima,
    this.noHp,
  });

  factory Alamat.fromRawJson(String str) => Alamat.fromJson(json.decode(str));
  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      idAlamat: (json['id_alamat'] as num?)?.toInt(),
      idPembeli: (json['id_pembeli'] as num?)?.toInt(),
      isDefault: (json['is_default'] as num?)?.toInt(),
      namaAlamat: json['nama_alamat'] as String?,
      labelAlamat: json['label_alamat'] as String?,
      namaPenerima: json['nama_penerima'] as String?,
      noHp: json['no_hp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alamat': idAlamat,
      'id_pembeli': idPembeli,
      'is_default': isDefault,
      'nama_alamat': namaAlamat,
      'label_alamat': labelAlamat,
      'nama_penerima': namaPenerima,
      'no_hp': noHp,
    };
  }
}