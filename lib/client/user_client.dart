import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:reusemart/entity/user.dart';


class UserClient {
  static final String endpoint = '/api';
  static final String url = '10.0.2.2:8000';



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
        Uri.http(url, '$endpoint/update-fcm-token'),
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
        Uri.http(url, '$endpoint/remove-fcm-token'),
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
        Uri.http(url, '$endpoint/getUserData'),
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
        Uri.http(url, '$endpoint/login'),
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
        Uri.http(url, '/api/logout'),
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
        Uri.http(url, '$endpoint/jumlah-pesanan-kurir'),
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



}
