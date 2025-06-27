import 'package:flutter/material.dart';
import 'package:reusemart/entity/pemesanan.dart';
import 'package:intl/intl.dart';
import 'package:reusemart/client/user_client.dart';
import 'package:reusemart/client/pemesanan_client.dart';

class DetailKomisi extends StatefulWidget {
  final String idBarang;
  final String idPemesanan;
  final String tanggalPemesanan;

  const DetailKomisi({
    required this.idBarang,
    required this.idPemesanan,
    required this.tanggalPemesanan,
    Key? key,
  }) : super(key: key);

  @override
  State<DetailKomisi> createState() => _DetailKomisiState();
}
  class _DetailKomisiState extends State<DetailKomisi> {
  bool isLoading = true;
  Map<String, dynamic>? barang;
  Map<String, dynamic>? penitip;
  Pemesanan? pemesanan;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    setState(() => isLoading = true);
    try {
      final barangData = await UserClient.getBarangById(widget.idBarang);
      final penitipData = await UserClient.getPenitipById(barangData['barang']['id_penitip']);
      final pemesananData = await PemesananClient.getPemesananByIdOrder(widget.idPemesanan);

      print("Penitip data: $penitipData");
      print("Pemesanan data: $pemesananData");

      if (mounted) {
        setState(() {
          barang = barangData['barang'];
          penitip = penitipData;
          pemesanan = pemesananData;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Gagal ambil data: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  String formatHarga(int harga) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(harga);
  }

  String formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return '-';
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(tanggal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF),
            Color.fromARGB(255, 255, 239, 223)
          ],
          stops: [0.64, 0.85],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 239, 223),
          title: const Text("Detail Komisi"),
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
    final komisiPersen = 5;
    final hargaBarang = barang!['harga_barang'] ?? 0;
    final totalKomisi = (hargaBarang * komisiPersen / 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gambar Barang
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://laraveledwardy.barioth.web.id/api/foto-barang/${barang!['id_barang']}/${barang!['foto_barang']}',
            height: 200,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 100),
          ),
        ),
        const SizedBox(height: 16),

        // Nama Barang
        Text(
          barang!['nama_barang'] ?? '',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        // Harga Barang
        Text(
          formatHarga(hargaBarang),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),

        Text("Penitip: ${penitip?['nama'] ?? '-'}"),
        Text("Tanggal Penjemputan: ${barang!['tanggal_masuk']}"),

        const SizedBox(height: 16),

        const Text("Rincian Komisi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green, decoration: TextDecoration.underline, decorationColor: Colors.green,)),
        const SizedBox(height: 4),
        Text("Basis Komisi : ${formatHarga(hargaBarang)}"),
        Text("Persentase Komisi : $komisiPersen%"),
        Text("Komisi Didapatkan :"),
        Text("${formatHarga(hargaBarang)} X $komisiPersen% = ${formatHarga(totalKomisi)}"),

        const SizedBox(height: 16),

        Row(
          children: [
            const Text("Total Komisi :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Text(
              formatHarga(totalKomisi),
              style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          "Komisi cair pada: ${formatTanggal(pemesanan?.tanggalDiterima)}",
          style: TextStyle(fontSize: 12, color: Colors.green),
        )
      ],
    );
  }

}