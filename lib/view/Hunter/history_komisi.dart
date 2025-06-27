import 'package:flutter/material.dart';
import 'package:reusemart/client/pemesanan_client.dart';
import 'package:reusemart/view/Hunter/detail_komisi.dart';
import '../../providers/providers.dart';

class HistoryKomisi extends StatefulWidget {
  const HistoryKomisi({super.key});

  @override
  State<HistoryKomisi> createState() => _HistoryKomisiState();
}

class _HistoryKomisiState extends State<HistoryKomisi> {
  bool _isLoading = true;
  List<dynamic> _komisiList = [];

  @override
  void initState() {
    super.initState();
    _loadKomisi();
  }

  Future<void> _loadKomisi() async {
    setState(() => _isLoading = true);
    try {
      final token = await UserNotifier.getAuthToken();
      final response = await PemesananClient.getKomisiHunter(token!);

      setState(() {
        _komisiList = response; 
        _isLoading = false;
      });
    } catch (e) {
      print('Gagal memuat komisi: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 239, 223),
        title: const Text(
          'Komisi Saya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
           : _komisiList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo/emptyboxrm.png',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lagi sepi nih..',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Belum ada komisi.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          )
        : Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 239, 223, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _komisiList.length,
                itemBuilder: (context, index) {
                  final item = _komisiList[index];

                  final barang = item['barang'] ?? {};
                  final idBarang = barang['id_barang'];
                  final fotoBarang = barang['foto_barang'];
                  final namaBarang = barang['nama_barang'] ?? 'Nama Barang';
                  final harga = barang['harga_barang'] ?? 0;
                  final komisi = item['komisi_hunter'] ?? 0;
                  final tanggalDiterima = item['tanggal_diterima'] ?? '-';
                  final idPemesanan = item['id_pemesanan'] ?? '-';
                  final tanggalPemesanan = item['tanggal_pemesanan'] ?? '-';

                  return GestureDetector(
                    onTap: () {
                      if (idBarang != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailKomisi(
                              idBarang: idBarang.toString(),
                              idPemesanan: idPemesanan.toString(),
                              tanggalPemesanan: tanggalPemesanan.toString(),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("ID Barang tidak ditemukan")),
                        );
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID Order : $idPemesanan",
                                    style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text("Komisi cair : $tanggalDiterima",
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Image.network(
                                  'https://laraveledwardy.barioth.web.id/api/foto-barang/$fotoBarang',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(namaBarang, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text("Rp$harga", style: const TextStyle(fontWeight: FontWeight.w500)),
                                      const Text("Persentase Komisi : 5%", style: TextStyle(fontSize: 12)),
                                      const SizedBox(height: 6),
                                      Text("Komisi didapatkan : Rp$komisi",
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 4, 121, 2),
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
