import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reusemart/entity/user.dart';
import 'package:reusemart/view/login_page.dart';
import 'package:reusemart/view/navbar.dart';
import '../../providers/providers.dart';
import 'package:reusemart/component/form_profile.dart';

class ProfileHunter extends ConsumerWidget {
  const ProfileHunter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 239, 223),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: usersAsync.when(
        data: (data) {
          if (data == null) {
            return Center(child: const Text('Tidak ada user (sudah logout)'));
          }
          
          final hunter = data as Pegawai;

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildHeader(context, hunter, ref),
                          const SizedBox(height: 40),
                          const Center(
                            child: Text(
                              'DETAIL PRIBADI',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 83, 83, 83),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 246, 237),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 166, 166, 166),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("USERNAME"),
                                    InputForm(
                                      value: hunter.nama ?? '',
                                      hintTxt: "Username",
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel("JABATAN"),
                                    InputForm(
                                      value: hunter.jabatan?.namaJabatan ?? "Tidak ada jabatan",
                                      hintTxt: "Jabatan",
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel("EMAIL"),
                                    InputForm(
                                      value: hunter.email ?? '',
                                      hintTxt: "Email",
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel("PASSWORD"),
                                    InputForm(
                                      password: true,
                                      value: hunter.password ?? '',
                                      hintTxt: "Password",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Pegawai hunter, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
      child: Row(
        children: [
          FutureBuilder<String?>(
            future: UserNotifier.getAuthToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text('Gagal mengambil token');
              }

              final token = snapshot.data!;
              return ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  'https://laraveledwardy.barioth.web.id/api/pegawai/foto-profile/${hunter.fotoProfile}',
                  headers: {'Authorization': 'Bearer $token'},
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              );
            },
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hunter.nama ?? '',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  hunter.email ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 166, 166, 166), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FutureBuilder<int>(
                    future: ref.read(userListProvider.notifier).getJumlahKomisiHunter(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        );
                      } else {
                        final jumlahKomisi = snapshot.data ?? 0;
                        return Text(
                          'Total Komisi: Rp $jumlahKomisi',
                          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
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
