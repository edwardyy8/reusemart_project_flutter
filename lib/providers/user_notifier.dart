import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../client/user_client.dart';
import '../entity/user.dart';
import 'dart:async';

final userClientProvider = Provider<UserClient>((ref) {
  return UserClient();
});

final userListProvider =
    AsyncNotifierProvider<UserNotifier, User>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<User> {
  late final UserClient _api;

  @override
  FutureOr<User> build() {
    // akan dijalankan sekali pertama kali
    _api = ref.read(userClientProvider);
    return _fetchCurrentUser();
  }

  Future<User> _fetchCurrentUser() async {
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

  
}