import 'dart:ffi';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:reusemart/entity/user.dart';
import 'package:reusemart/entity/kategori.dart';
import 'package:reusemart/entity/merchandise.dart';

class UserClient {
  static final String endpoint = '/api';
  static final String url = 'laraveledwardy.barioth.web.id';
  // static final String url = '10.53.4.144:8000';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Mengambil token dari SharedPreferences
  }

  static Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_type'); 
  }

  static Future<String?> getFcmToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      print("FCM Token: $token");
      return token;
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }

  static Future<void> sendFcmTokenToBackend(String userId, String userType, String fcmToken, String token) async {
    try {
      final response = await post(
        Uri.https(url, '$endpoint/update-fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'user_type': userType,
          'fcm_token': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        print('FCM token updated successfully: ${response.body}');
      } else {
        print('Failed to update FCM token: ${response.body}');
      }
    } catch (e) {
      print('Error sending FCM token: $e');
    }
  }

  static Future<void> removeFcmTokenOnLogout(String token) async {
    try {
      final response = await post(
        Uri.https(url, '$endpoint/remove-fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );
      if (response.statusCode == 200) {
        print('FCM token removed from server');
      } else {
        print('Failed to remove FCM token: ${response.body}');
      }
    } catch (e) {
      print('Error removing FCM token: $e');
    }
  }

  Future<User> fetchCurrentUser() async {
    try {
      String? token = await getAuthToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }

      final response = await get(
        Uri.https(url, '$endpoint/getUserData'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(response.body);
      

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        final String role = data['role'];
        final Map<String, dynamic> userData = data['user'];
        
        switch (role) {
          case 'penitip':
            return Penitip.fromJson(userData);
          case 'pegawai':
            return Pegawai.fromJson(userData);
          default:
            return Pembeli.fromJson(userData);
        }
    
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {

    try {
      var response = await post(
        Uri.https(url, '$endpoint/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Email atau password salah');
      }

      var data = json.decode(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_type', data['user_type']);
      await prefs.setString('auth_token', data['token']);
      await prefs.setString('jabatan', data['jabatan'] ?? '');
      await prefs.setString('user_id', data['id'].toString());

      return {
        'user_type': data['user_type'],
        'token': data['token'],
        'statusCode': response.statusCode,
        'user_id': data['id'].toString(),
        'jabatan': data['jabatan'] ?? '',
      };
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> logout(String token) async {
    try {
      var response = await post(
        Uri.https(url, '/api/logout'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.reasonPhrase}');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_type');
      await prefs.remove('jabatan');
      await prefs.remove('user_id');

      print('Logout successful');
    } catch (e) {
      return Future.error('Logout error: $e');
    }
  }

  Future<int> getJumlahPesananKurir(String token) async {
    try {
      final response = await get(
        Uri.https(url, '$endpoint/jumlah-pesanan-kurir'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Jumlah pesanan kurir: $data');
        return data['data'] ?? 0;
      } else {
        throw Exception('Failed to fetch jumlah pesanan kurir');
      }
    } catch (e) {
      throw Exception('Error fetching jumlah pesanan kurir: $e');
    }
  }

  Future<int> getJumlahItemHunter(String token) async {
    try {
      final response = await get(
        Uri.https(url, '$endpoint/jumlah-item-hunter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Jumlah item hunter: $data');
        return data['data'] ?? 0;
      } else {
        throw Exception('Failed to fetch jumlah item hunter');
      }
    } catch (e) {
      throw Exception('Error fetching jumlah item hunter: $e');
    }
  }

  Future<int> getJumlahKomisiHunter(String token) async {
    try {
      final response = await get(
        Uri.https(url, '$endpoint/getJumlahKomisiHunter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Total komisi hunter: $data');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return (data['data'] ?? 0);
      } else {
        throw Exception('Failed to fetch total komisi hunter');
      }
    } catch (e) {
      throw Exception('Error fetching total komisi hunter: $e');
    }
  }

  static Future<List<Kategori>> getAllKategoris() async {
    final response = await get(
      Uri.https(url, '$endpoint/kategori'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];
      return data.map((e) => Kategori.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load kategoris');
    }
  }

  static Future<List<dynamic>> getAllBarangs() async {
    try {
      final response = await get(
        Uri.https(url, '$endpoint/barang'),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data['data'] ?? 0;
      } else {
        throw Exception('Failed to fetch barang');
      }
    } catch (e) {
      throw Exception('Error fetching barang: $e');
    }
  }

  static Future<Map<String, dynamic>> getBarangById(String id) async {
    try {
      final uri = Uri.https(url, '$endpoint/barang/$id');
      print('Fetching from: $uri');

      final response = await get(uri, headers: {'Accept': 'application/json'});
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] == null || data['data']['barang'] == null) {
          throw Exception('Data barang tidak tersedia di response');
        }

        return {
          'barang': data['data']['barang'],
          'jumlah_terjual': data['data']['jumlah_barang_terjual'],
        };
      } else if (response.statusCode == 404) {
        throw Exception('Barang tidak ditemukan');
      } else {
        throw Exception('Gagal mengambil data barang');
      }
    } catch (e) {
      throw Exception('Error fetching barang by ID: $e');
    }
  }


  static Future<Map<String, dynamic>> getPenitipById(String id) async {
    try {
      final response = await get(
        Uri.https(url, '$endpoint/penitip/$id'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']; // langsung penitip-nya
      } else if (response.statusCode == 404) {
        throw Exception('Penitip tidak ditemukan');
      } else {
        throw Exception('Gagal mengambil data penitip');
      }
    } catch (e) {
      throw Exception('Error fetching penitip by ID: $e');
    }
  }

  static Future<int> getPoinPembeli(String token) async {
    try{
      final response = await get(
        Uri.https(url, '$endpoint/pembeli/pembeliProfile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Jumlah poin pembeli: $data');
        final poinPembeli = data['pembeli']?['poin_pembeli'];
        print('Poin pembeli: $poinPembeli');
        return int.tryParse(poinPembeli.toString()) ?? 0;
      } else {
        throw Exception('Gagal mendapatkan poin pembeli');
      }
    } catch (e) {
      throw Exception('Error fetching poin pembeli: $e');
    }
    
  }

  static Future<List<Merchandise>> getAllMerchandise() async {
    try {
      final response = await get(
        Uri.https(url, '$endpoint/merchandise'),
          headers: {
          'Accept': 'application/json'
          },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List data = jsonData['data'];
        return data.map((e) => Merchandise.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load kategoris');
      }
    }catch (e) {
      throw Exception('Error fetching poin pembeli: $e');
    }
  }

  static Future<Map<String, dynamic>> claimMerchandise(String token, int idMerchandise) async {
    try {
      final response = await post(
        Uri.https(url, '$endpoint/claimMerchandise/$idMerchandise'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = json.decode(response.body);

      return {
        'statusCode': response.statusCode,
        'message': data['message'] ?? '',
      };
    } catch (e) {
      print('Error klaim merchandise: $e');
      return {
        'statusCode': 500,
        'message': 'Terjadi kesalahan saat klaim merchandise',
      };
    }
  }


}
