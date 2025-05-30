import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:reusemart/client/user_client.dart';
import 'package:reusemart/view/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Center(
            child: const Text('Welcome to the Home Page!'),
          ),
          ElevatedButton(
            onPressed: () {
              _onLogout();
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    ); 
  }

  void _onLogout() async {
    try {
      var token = await UserClient.getAuthToken();

      await UserClient.removeFcmTokenOnLogout(token!);

      await UserClient.logout(token);

      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: false,
        title: 'Success',
        desc: 'Logout Berhasil! Kami berharap Anda kembali lagi.',
        dismissOnTouchOutside: false,
        btnOkOnPress: () {
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (Route<dynamic> route) => false,
          );
        },
        btnOkIcon: Icons.check_circle,
      ).show();
      
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        showCloseIcon: true,
        title: 'Error',
        desc: 'Logout gagal. Silahkan coba lagi.',
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
      ).show();
      print('Logout error: $e');
    }
  }
}