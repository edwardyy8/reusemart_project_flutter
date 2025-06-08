import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reusemart/entity/kategori.dart';
import 'package:reusemart/entity/merchandise.dart';
import 'package:reusemart/entity/pemesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../client/user_client.dart';
import '../client/pemesanan_client.dart';
import '../entity/user.dart';
import 'dart:async';

final userClientProvider = Provider<UserClient>((ref) {
  return UserClient();
});

final userListProvider =
    AsyncNotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<User?> {
  late final UserClient _api;

  @override
  FutureOr<User?> build() {
    // akan dijalankan sekali pertama kali
    _api = ref.read(userClientProvider);
    return _fetchCurrentUser();
  }

  Future<User?> _fetchCurrentUser() async {
    final data = await _api.fetchCurrentUser();
    return data;
  }

  /// public method untuk refresh data manual
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final user = await _fetchCurrentUser();
    state = AsyncValue.data(user);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<int> getJumlahPesananKurir() async {
    final token = await getAuthToken();
    if (token == null) {
      return 0;
    }
    return _api.getJumlahPesananKurir(token);
  }

  Future<int> getJumlahItemHunter() async {
    final token = await getAuthToken();
    if (token == null) {
      return 0;
    }
    return _api.getJumlahItemHunter(token);
  }

   Future<int> getJumlahKomisiHunter() async {
    final token = await getAuthToken();
    if (token == null) {
      return 0;
    }
    return _api.getJumlahKomisiHunter(token);
  }

  static Future<List<Kategori>> getAllKategoris() async {
    return await UserClient.getAllKategoris();
  }

  static Future<List<dynamic>> getAllBarangs() async {
    return await UserClient.getAllBarangs();
  }

  static Future<Map<String, dynamic>> getBarangById(String id) async {
    return await UserClient.getBarangById(id);
  }

  static Future<Map<String, dynamic>> getPenitipById(String id) async {
    return await UserClient.getPenitipById(id);
  }

  static Future<List<Merchandise>> getAllMerchandise() async {
    return await UserClient.getAllMerchandise();
  }

  static Future<List<dynamic>> getKomisiHunter(String token) async {
    return await PemesananClient.getKomisiHunter(token);
  }

  Future<int> getPoinPembeli() async {
    final token = await getAuthToken();
    if (token == null) {
      return 0;
    }
    return await UserClient.getPoinPembeli(token);
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final token = await getAuthToken();
      if (token != null) {
        await UserClient.removeFcmTokenOnLogout(token);
        await UserClient.logout(token);
      }
      
      state = AsyncValue.data(null); 
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
}