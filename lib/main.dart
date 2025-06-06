import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reusemart/view/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  // Pastikan binding Flutter diinisialisasi terlebih dahulu
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Firebase
  await Firebase.initializeApp();
  
  // Setup push notification
  await setupPushNotifications();

  runApp(ProviderScope(child: MyApp()));
}


// Fungsi untuk konfigurasi FCM
Future<void> setupPushNotifications() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Inisialisasi flutter_local_notifications
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request izin notifikasi (untuk iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Dapatkan token FCM
  String? token = await messaging.getToken();
  if (token == null) {
    print('Gagal mendapatkan FCM token');
    return;
  }
  print('FCM Token: $token');

  // Handler untuk notifikasi saat aplikasi aktif (foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Pesan diterima (foreground): ${message.notification?.title}');
    if (message.notification != null) {
      // Tampilkan notifikasi lokal
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // ID channel
            'High Importance Notifications', // Nama channel
            channelDescription: 'Digunakan untuk notifikasi penting',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  // Handler untuk notifikasi saat aplikasi di background/terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

// Handler untuk background/terminated (harus top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Pesan diterima (background): ${message.notification?.title}');
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SplashScrenn(), 
      ), 
    );
  }
}

