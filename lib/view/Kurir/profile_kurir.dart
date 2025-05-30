import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reusemart/entity/user.dart';
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
                                  'http://10.0.2.2:8000/api/pegawai/foto-profile/${kurir.fotoProfile}',
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
                  height: MediaQuery.of(context).size.height * 0.45,
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
            
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
