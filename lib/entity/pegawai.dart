import 'dart:convert';

class Pegawai {
  String? idPegawai;
  int? idJabatan;
  String? nama;
  String? email;
  String? password;
  String? fotoProfile;
  DateTime? tanggalLahir;
  DateTime? createdAt;
  String? isAktif; 
  String? fcmToken;

  Pegawai({
    this.idPegawai,
    this.idJabatan,
    this.nama,
    this.email,
    this.password,
    this.fotoProfile,
    this.tanggalLahir,
    this.createdAt,
    this.isAktif,
    this.fcmToken,
  });

  factory Pegawai.fromRawJson(String str) => Pegawai.fromJson(json.decode(str));
  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      idPegawai: json['id_pegawai'],
      idJabatan: json['id_jabatan'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      fotoProfile: json['foto_profile'],
      tanggalLahir: DateTime.parse(json['tanggal_lahir']),
      createdAt: DateTime.parse(json['created_at']),
      isAktif: json['is_aktif'],
      fcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pegawai': idPegawai,
      'id_jabatan': idJabatan,
      'nama': nama,
      'email': email,
      'password': password,
      'foto_profile': fotoProfile,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'is_aktif': isAktif,
      'fcm_token': fcmToken,
    };
  }
}