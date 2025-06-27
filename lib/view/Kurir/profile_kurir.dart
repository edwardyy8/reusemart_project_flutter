import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reusemart/client/user_client.dart';
import 'package:reusemart/entity/user.dart';
import 'package:reusemart/view/login_page.dart';
import 'package:reusemart/view/navbar.dart';
import '../../providers/providers.dart';
import 'package:reusemart/component/form_profile.dart';


class ProfileKurir extends ConsumerWidget {
  const ProfileKurir({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);
    final formKey = GlobalKey<FormState>();    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 239, 223),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Profil Saya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
          ],
        ),
      ),
      body: usersAsync.when(
        data: (data) {
          if (data == null) {
            return Center(child: const Text('Tidak ada user (sudah logout)'));
          }

          final kurir = data as Pegawai;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 239, 223, 1),
                        Color.fromRGBO(255, 255, 255, 1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 7),
                        Row(
                          children: [
                            FutureBuilder<String?>(
                              future: UserNotifier.getAuthToken(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                                  return Text('Gagal mengambil token');
                                }
                                          
                                final token = snapshot.data!;
                                return Image.network(
                                  'https://laraveledwardy.barioth.web.id/api/pegawai/foto-profile/${kurir.fotoProfile}',
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                  width: 100,
                                  height: 100,
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${kurir.nama}',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${kurir.email}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 166, 166, 166),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: FutureBuilder<int>(
                                    future: ref.read(userListProvider.notifier).getJumlahPesananKurir(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Text(
                                          'Loading...',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.red,
                                          ),
                                        );
                                      } else {
                                        final jumlahPesanan = snapshot.data ?? 0;
                                        return Text(
                                          '$jumlahPesanan paket diantar',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey[800],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  'DETAIL PRIBADI',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 83, 83, 83),
                  ),
                ),
                SizedBox(height: 30),
                // form
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 246, 237),
                    border: Border.all(
                      color: Color.fromARGB(255, 166, 166, 166),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "USERNAME",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InputForm(  
                              value: kurir.nama!,
                              hintTxt: "Username"
                            ),
                            
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "JABATAN",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InputForm(  
                              value: kurir.jabatan?.namaJabatan! ?? "Tidak ada jabatan",
                              hintTxt: "Jabatan"
                            ),
                            
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "EMAIL",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InputForm(
                              value: kurir.email!,
                              hintTxt: "Email",
                            ),
                                    
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "PASSWORD",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InputForm(
                              password: true,
                              value: kurir.password!,
                              hintTxt: "Password",
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showConfirmation(context, ref),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: Color.fromARGB(255, 255, 239, 223),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.logout,
                        size: 22,
                        color: Color.fromARGB(255, 4, 121, 2),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 4, 121, 2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _showConfirmation(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          title: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 239, 223),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: const Text(
              'Konfirmasi Logout',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin logout dari aplikasi?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Tidak', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 4, 121, 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Iya', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                _onLogout(context, ref);
              },
            ),
          ],
        );
      },
    );
  }

  void _onLogout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(userListProvider.notifier).logout();

      if (!context.mounted) return;

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
            MaterialPageRoute(builder: (_) => NavBar(userType: "lain")),
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
