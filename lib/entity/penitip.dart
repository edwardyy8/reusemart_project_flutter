part of 'user.dart';

class Penitip implements User {
  String? idPenitip;
  String? nama;
  double? ratingPenitip;
  int? saldoPenitip;
  int? poinPenitip;
  String? noKtp;
  String? email;
  String? password;
  String? isTop;
  String? fotoKtp;
  DateTime? createdAt;
  String? fotoProfile;
  String? isAktif;
  String? fcmToken;

  Penitip({
    this.idPenitip,
    this.nama,
    this.ratingPenitip,
    this.saldoPenitip,
    this.poinPenitip,
    this.noKtp,
    this.email,
    this.password,
    this.isTop,
    this.fotoKtp,
    this.createdAt,
    this.fotoProfile,
    this.isAktif,
    this.fcmToken,
  });

  factory Penitip.fromRawJson(String str) => Penitip.fromJson(json.decode(str));
  factory Penitip.fromJson(Map<String, dynamic> json) {
    return Penitip(
      idPenitip: json['id_penitip'],
      nama: json['nama'],
      ratingPenitip: json['rating_penitip'] != null
          ? (double.tryParse(json['rating_penitip'].toString()) ?? 0.0)
          : null,
      saldoPenitip: json['saldo_penitip'] != null
          ? (int.tryParse(json['saldo_penitip'].toString()) ?? 0)
          : null,
      poinPenitip: json['poin_penitip'] != null
          ? (int.tryParse(json['poin_penitip'].toString()) ?? 0)
          : null,
      noKtp: json['no_ktp'],
      email: json['email'],
      password: json['password'],
      isTop: json['is_top'],
      fotoKtp: json['foto_ktp'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      fotoProfile: json['foto_profile'],
      isAktif: json['is_aktif'],
      fcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_penitip': idPenitip,
      'nama': nama,
      'rating_penitip': ratingPenitip,
      'saldo_penitip': saldoPenitip,
      'poin_penitip': poinPenitip,
      'no_ktp': noKtp,
      'email': email,
      'password': password,
      'is_top': isTop,
      'foto_ktp': fotoKtp,
      'createdAt': createdAt?.toIso8601String(),
      'foto_profile': fotoProfile,
      'is_aktif': isAktif,
      'fcm_token': fcmToken,
    };
  }
}
