import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reusemart/client/user_client.dart';

class DetailBarangPage extends StatefulWidget {
  final String idBarang;

  const DetailBarangPage({required this.idBarang, Key? key}) : super(key: key);

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  bool isLoading = true;
  Map<String, dynamic>? barang;
  Map<String, dynamic>? penitip;
  int? jumlah_terjual;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    setState(() => isLoading = true);
    try {
      final barangData = await UserClient.getBarangById(widget.idBarang);
      final penitipData =
          await UserClient.getPenitipById(barangData['barang']['id_penitip']);
      print("Penitip data: $penitipData");
      if (mounted) {
        setState(() {
          barang = barangData['barang'];
          jumlah_terjual = barangData['jumlah_barang_terjual'];
          penitip = penitipData;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Gagal ambil data: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  String formatHarga(int harga) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(harga);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color.fromARGB(255, 255, 239, 223)],
          stops: [0.64, 0.85],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 239, 223),
          title: const Text("Detail Produk"),
          elevation: 0,
          titleSpacing: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (barang == null || penitip == null)
                ? const Center(child: Text("Barang tidak ditemukan."))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: buildDetailContent(),
                  ),
      ),
    );
  }

  Widget buildDetailContent() {
    final garansiAktif =
        DateTime.parse(barang!['tanggal_garansi']).isAfter(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'http://192.168.88.116:8000/api/foto-barang/${barang!['id_barang']}/${barang!['foto_barang']}',
            height: 200,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 100),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          formatHarga(barang!['harga_barang']),
          style: const TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          barang!['nama_barang'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
            "${barang!['status_barang']} • ${garansiAktif ? "Garansi" : "Tanpa Garansi"} • ${barang!['berat_barang']}Kg"),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  'http://10.0.2.2:8000/api/penitip/foto-profile/${penitip!['foto_profile']}',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.account_circle, size: 48),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (penitip!['is_top'] == "Ya") ...[
                        Image.asset(
                          'lib/assets/images/iconbadge.png',
                          width: 20,
                          height: 20,
                        ),
                      ],
                      Text(
                        penitip!['nama'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (penitip!['is_top'] == "Ya")
                    const Text(
                      "TOP SELLER",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  const Text("penitip ReuseMart",
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(" ${penitip!['rating_penitip'] ?? 0}"),
                      const SizedBox(width: 12),
                      Text("Barang Terjual : ${jumlah_terjual ?? 0}")
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text("Deskripsi Produk",
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 4),
        Text(barang!['deskripsi'] ?? "-", style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
