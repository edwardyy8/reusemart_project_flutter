import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reusemart/entity/user.dart';
import '../../providers/providers.dart';
import 'package:reusemart/component/form_profile.dart';

class ProfilePembeli extends ConsumerWidget {
  const ProfilePembeli({super.key});

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
          final pembeli = data as Pembeli;

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(context, pembeli, ref),
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
                                      value: pembeli.nama ?? '',
                                      hintTxt: "Username",
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel("JABATAN"),
                                    InputForm(
                                      value: "Pembeli",
                                      hintTxt: "Jabatan",
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel("EMAIL"),
                                    InputForm(
                                      value: pembeli.email ?? '',
                                      hintTxt: "Email",
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel("PASSWORD"),
                                    InputForm(
                                      password: true,
                                      value: pembeli.password ?? '',
                                      hintTxt: "Password",
                                    ),
                                  ],
                                ),
                              ),
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

  Widget _buildHeader(BuildContext context, Pembeli pembeli, WidgetRef ref) {
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
                  'http://10.0.2.2:8000/api/pembeli/foto_profile/${pembeli.fotoProfile}',
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
                  pembeli.nama ?? '',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  pembeli.email ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 166, 166, 166), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${pembeli.poinPembeli ?? 0} poin loyalitas',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
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
}