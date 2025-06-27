import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reusemart/entity/rincian_penitipan.dart';

class PenitipanClient {
  static const String endpoint = '/api';
  static const String url = 'laraveledwardy.barioth.web.id';

  static Future<List<Rincian_Penitipan>> getPenitipanByIdPenitip(String idPenitip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.https(url, '$endpoint/getPenitipanByIdPenitip/$idPenitip'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonResponse['status'] == true) {
        final data = jsonResponse['data'] as List<dynamic>;
        return data.map((item) => Rincian_Penitipan.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Gagal ambil data penitipan: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to load penitipan data: ${response.body}');
    }
  }
}