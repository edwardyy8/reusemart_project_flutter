part of 'user.dart';

class Pembeli implements User {
  int? idPembeli;
  String? nama;
  String? email;
  String? password;
  String? isAktif;
  int? poinPembeli;
  String? fotoProfile;
  String? fcmToken;

  Pembeli({
    this.idPembeli,
    this.nama,
    this.email,
    this.password,
    this.isAktif,
    this.poinPembeli,
    this.fotoProfile,
    this.fcmToken,
  });

  factory Pembeli.fromRawJson(String str) => Pembeli.fromJson(json.decode(str));
  factory Pembeli.fromJson(Map<String, dynamic> json) {
    return Pembeli(
      idPembeli: json['id_pembeli'] != null
          ? int.tryParse(json['id_pembeli'].toString())
          : null,
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      isAktif: json['is_aktif'],
      poinPembeli: json['poin_pembeli'] != null
          ? int.tryParse(json['poin_pembeli'].toString())
          : null,
      fotoProfile: json['foto_profile'],
      fcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pembeli': idPembeli,
      'nama': nama,
      'email': email,
      'password': password,
      'is_aktif': isAktif,
      'poin_pembeli': poinPembeli,
      'foto_profile': fotoProfile,
      'fcm_token': fcmToken,
    };
  }
}