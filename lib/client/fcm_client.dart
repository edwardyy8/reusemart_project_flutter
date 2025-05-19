import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFcmToken() async {
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