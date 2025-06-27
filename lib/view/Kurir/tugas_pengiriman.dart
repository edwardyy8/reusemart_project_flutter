import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reusemart/client/pemesanan_client.dart';
import 'package:reusemart/entity/pemesanan.dart';
import 'package:reusemart/view/Kurir/detail_pengiriman.dart';

class TugasPengiriman extends StatefulWidget {
  const TugasPengiriman({super.key});

  @override
  State<TugasPengiriman> createState() => _TugasPengirimanState();
}

class _TugasPengirimanState extends State<TugasPengiriman> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 239, 223),
        title: const Text(
          'Tugas Pengiriman Saya',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Histori'),
          ],
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          labelColor: Color.fromARGB(255, 4, 121, 2),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color.fromARGB(255, 4, 121, 2),
          indicatorWeight: 3,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 247, 239, 1),
              Color.fromRGBO(255, 239, 223, 1),
            ],
            stops: [0.0, 0.28, 1.0],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder(
            future: PemesananClient.getPemesananKurir(),
            initialData: const {'pemesananAktif': [], 'pemesananHistori': []},
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available'));
              }else {
                final data = snapshot.data as Map<String, List<Pemesanan>>;
                final pemesananAktif = data['pemesananAktif'] ?? [];
                final pemesananHistori = data['pemesananHistori'] ?? [];
              
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Aktif Tab
                    pemesananAktif.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/logo/emptyboxrm.png',
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'Lagi sepi nih..',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text('Belum ada tugas pengiriman aktif saat ini.'),
                              ],
                            )
                          )
                        : ListView.builder(
                            itemCount: pemesananAktif.length,
                            itemBuilder: (context, index) {
                              final pemesanan = pemesananAktif[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(   
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailPengiriman(pemesanan: pemesanan),
                                            ),
                                          );
                                        },
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'ID Pemesanan: ${pemesanan.idPemesanan}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  child: Text(
                                                    'Menunggu',
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Tangggal pengiriman: ${pemesanan.tanggalPengiriman?.toLocal().toString().split(' ')[0] ?? 'Tidak diketahui'}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 5),
                                            Divider(
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${pemesanan.alamat?.namaPenerima}',
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              '${pemesanan.alamat?.noHp}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '${pemesanan.alamat?.namaAlamat}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'List Barang:',
                                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                            ),
                                            ...pemesanan.rincianPemesanan?.map((rincian) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(
                                                        'https://laraveledwardy.barioth.web.id/storage/foto_barang/${rincian.barang?.fotoBarang}',
                                                        width: 70,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      '${rincian.barang?.namaBarang} - ${rincian.barang?.beratBarang} Kg',
                                                      style: const TextStyle(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList() ?? [],
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => DetailPengiriman(pemesanan: pemesanan),
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      side: const BorderSide(
                                                        color: Color.fromARGB(255, 4, 121, 2),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                  ),
                                                  child: Text(
                                                    'Lihat Detail',
                                                    style: TextStyle(
                                                      fontSize: 16, 
                                                      fontWeight: FontWeight.bold,
                                                      color: Color.fromARGB(255, 4, 121, 2),
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _showConfirmation(pemesanan.idPemesanan!);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromARGB(255, 4, 121, 2),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                  ),
                                                  child: Text(
                                                    'Tandai Selesai',
                                                    style: TextStyle(
                                                      fontSize: 16, 
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                
                    // Histori Tab
                    pemesananHistori.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/logo/emptyboxrm.png',
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'Lagi sepi nih..',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text('Belum ada tugas pengiriman histori saat ini.'),
                              ],
                            )
                          )
                        : ListView.builder(
                            itemCount: pemesananHistori.length,
                            itemBuilder: (context, index) {
                              final pemesanan = pemesananHistori[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(   
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailPengiriman(pemesanan: pemesanan),
                                            ),
                                          );
                                        },
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'ID Pemesanan: ${pemesanan.idPemesanan}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(255, 4, 121, 2),
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  child: Text(
                                                    'Selesai',
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Tangggal pengiriman: ${pemesanan.tanggalPengiriman?.toLocal().toString().split(' ')[0] ?? 'Tidak diketahui'}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 5),
                                            Divider(
                                              color: Colors.grey,
                                              height: 1,
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${pemesanan.alamat?.namaPenerima}',
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              '${pemesanan.alamat?.noHp}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '${pemesanan.alamat?.namaAlamat}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'List Barang:',
                                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                            ),
                                            ...pemesanan.rincianPemesanan?.map((rincian) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(
                                                        'https://laraveledwardy.barioth.web.id/storage/foto_barang/${rincian.barang?.fotoBarang}',
                                                        width: 70,
                                                        height: 70,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      '${rincian.barang?.namaBarang} - ${rincian.barang?.beratBarang} Kg',
                                                      style: const TextStyle(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList() ?? [],
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => DetailPengiriman(pemesanan: pemesanan),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    side: const BorderSide(
                                                      color: Color.fromARGB(255, 4, 121, 2),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                ),
                                                child: Text(
                                                  'Lihat Detail',
                                                  style: TextStyle(
                                                    fontSize: 16, 
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(255, 4, 121, 2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                );
              }
            }
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmation(String idPemesanan) async {
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
              'Tandai Selesai Pengiriman',
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
                Text('Apakah Anda yakin ingin menandai pengiriman ini sebagai selesai?'),
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
                Navigator.of(context).pop();
                _tandaiSelesaiKirim(idPemesanan);
              },
            ),
          ],
        );
      },
    );
  }

  void _tandaiSelesaiKirim(String idPemesanan) async {
    try {
      await PemesananClient.terimaSelesaiKirim(idPemesanan);

      if (!mounted) return;
      
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: false,
        title: 'Success',
        desc: 'Berhasil! Anda sudah selesai mengirim pemesanan.',
        dismissOnTouchOutside: false,
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
      ).show();
      
      setState(() {});
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        showCloseIcon: true,
        title: 'Error',
        desc: 'Gagal menandain selesai pada pengiriman ini. Silahkan coba lagi.',
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
      ).show();
      print('Tandain selesai error: $e');
    }
  }
}