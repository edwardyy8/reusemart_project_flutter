part of 'user.dart';

class Pegawai implements User {
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
  Jabatan? jabatan;

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
    this.jabatan,
  });

  factory Pegawai.fromRawJson(String str) => Pegawai.fromJson(json.decode(str));
  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      idPegawai: json['id_pegawai'],
      idJabatan: json['id_jabatan'] != null
        ? int.tryParse(json['id_jabatan'].toString())
        : null,
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      fotoProfile: json['foto_profile'],
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.tryParse(json['tanggal_lahir'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      isAktif: json['is_aktif'],
      fcmToken: json['fcm_token'],
      jabatan: json['jabatan'] != null
          ? Jabatan.fromJson(json['jabatan'])
          : null,
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
      'createdAt': createdAt?.toIso8601String(),
      'is_aktif': isAktif,
      'fcm_token': fcmToken,
      'jabatan': jabatan?.toJson(),
    };
  }
}