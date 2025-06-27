import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:reusemart/entity/pemesanan.dart';

class PemesananClient {
  static final String endpoint = '/api';
  static final String url = 'laraveledwardy.barioth.web.id';
  // static final String url = '10.53.4.144:8000';

  static Future<Map<String, List<Pemesanan>>> getPemesananKurir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await get(
      Uri.https(url, '$endpoint/getPemesananKurir'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
   
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      
      final data = jsonResponse['data'] as Map<String, dynamic>; 

      final pemesananAktif = (data['pemesananAktif'] as List<dynamic>)
          .map((item) => Pemesanan.fromJson(item as Map<String, dynamic>))
          .toList();
          
      final pemesananHistori = (data['pemesananHistori'] as List<dynamic>)
          .map((item) => Pemesanan.fromJson(item as Map<String, dynamic>))
          .toList();
     
      return {
        'pemesananAktif': pemesananAktif,
        'pemesananHistori': pemesananHistori,
      };
    } else {
      throw Exception('Failed to load pemesanan: ${response.body}');
    }
  }

  static Future<void> terimaSelesaiKirim(String idPemesanan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await post(
      Uri.https(url, '$endpoint/terimaSelesaiKirim/$idPemesanan'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pemesanan: ${response.body}');
    }
    
  }
  
  static Future<List<dynamic>> getKomisiHunter(String token) async {
    final response = await get(
      Uri.https(url, '$endpoint/getKomisiHunter'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load komisi: ${response.body}');
    }
  }

  static Future<Pemesanan> getPemesananByIdOrder(String idPemesanan) async {

    final response = await get(
      Uri.https(url, '$endpoint/getPemesananByIdOrder/$idPemesanan'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonResponse['status'] == true) {
        final data = jsonResponse['data'] as Map<String, dynamic>;
        return Pemesanan.fromJson(data);
      } else {
        throw Exception('Gagal ambil data pemesanan: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load pemesanan by ID: ${response.body}');
    }
  }

  // Pembeli - Pemesanan
  static Future<List<Pemesanan>> getPemesananByIdPembeli(String idPembeli) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await get(
      Uri.https(url, '$endpoint/getPemesananByIdPembeli/$idPembeli'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonResponse['status'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data
            .map((item) => Pemesanan.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal ambil data pemesanan: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load pemesanan by pembeli: ${response.body}');
    }
  }

  static Future<Pemesanan> getPemesananByIdPemesanan(String idPemesanan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await get(
      Uri.https(url, '$endpoint/getPemesananByIdPemesanan/$idPemesanan'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonResponse['status'] == true) {
        final data = jsonResponse['data'] as Map<String, dynamic>;
        return Pemesanan.fromJson(data);
      } else {
        throw Exception('Gagal ambil data pemesanan: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load pemesanan by ID: ${response.body}');
    }
  }
}