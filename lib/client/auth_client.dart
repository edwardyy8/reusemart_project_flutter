import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthClient {
  static final String endpoint = '/api';
  static final String url = '10.0.2.2:8000';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Mengambil token dari SharedPreferences
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

  // static Future<User> fetchCurrentUser() async {
  //   try {
  //     String? token = await getAuthToken();
  //     if (token == null) {
  //       throw Exception('User is not authenticated');
  //     }

  //     // Membuat request ke API untuk mengambil data user yang sedang login
  //     final response = await get(
  //       Uri.http(url, endpoint),
  //       headers: {
  //         'Authorization': 'Bearer $token', // Menambahkan token ke header
  //         'Accept': 'application/json',
  //       },
  //     );

  //     print(response.body);
  //     print(token);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Jika response berhasil, parse JSON menjadi objek User
  //       final data = json.decode(response.body);
  //       return User.fromJson(data); // Mengembalikan objek User
  //     } else {
  //       throw Exception('Failed to load user data');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching user: $e');
  //   }
  // }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {

    try {
      // Mengirim data login
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

      String token = data['token'];
      print(token);
      print(response.statusCode);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_type', data['user_type']);
      await prefs.setString('auth_token', token);
      await prefs.setString('jabatan', data['jabatan'] ?? '');

      return {
        'user_type': data['user_type'],
        'token': data['token'],
        'statusCode': response.statusCode,
        'user_id': data['id'],
      };
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Simpan token baru
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

      print('Logout successful');
    } catch (e) {
      return Future.error('Logout error: $e');
    }
  }

}
