import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reusemart/client/penitipan_client.dart';
import 'package:reusemart/entity/rincian_penitipan.dart';

class RiwayatPenitipanPage extends StatefulWidget {
  const RiwayatPenitipanPage({Key? key}) : super(key: key);

  @override
  _RiwayatPenitipanPageState createState() => _RiwayatPenitipanPageState();
}

class _RiwayatPenitipanPageState extends State<RiwayatPenitipanPage> {
  List<Rincian_Penitipan> _rincianList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPenitipan();
  }

  Future<void> _fetchPenitipan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idPenitip = prefs.getString('id_penitip') ?? prefs.getString('user_id');
      String? userType = prefs.getString('user_type');

      if (idPenitip == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'ID Penitip tidak ditemukan. Silakan login kembali.';
        });
        return;
      }

      if (userType != 'penitip') {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Fitur ini hanya tersedia untuk pengguna tipe penitip.';
        });
        return;
      }

      final rincianList = await PenitipanClient.getPenitipanByIdPenitip(idPenitip);
      setState(() {
        _rincianList = rincianList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat riwayat penitipan: $e';
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Belum tersedia';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return 'Tidak tersedia';
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  void _showDetailDialog(BuildContext context, Rincian_Penitipan rincian) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Penitipan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID Rincian Penitipan: ${rincian.idRincianPenitipan ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('ID Penitipan: ${rincian.idPenitipan ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('ID Barang: ${rincian.idBarang ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Nama Barang: ${rincian.barang?.namaBarang ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Harga Barang: ${_formatCurrency(rincian.barang?.hargaBarang)}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Tanggal Masuk: ${_formatDate(rincian.penitipan?.tanggalMasuk)}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Tanggal Akhir: ${_formatDate(rincian.tanggalAkhir)}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Batas Akhir: ${_formatDate(rincian.batasAkhir)}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Perpanjangan: ${rincian.perpanjangan ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('Status Penitipan: ${rincian.statusPenitipan ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('ID Penitip: ${rincian.penitipan?.idPenitip ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('ID QC: ${rincian.penitipan?.idQc ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              Text('ID Hunter: ${rincian.penitipan?.idHunter ?? "Tidak tersedia"}',
                  style: const TextStyle(color: Colors.black87)),
              if (rincian.barang?.fotoBarang != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://laraveledwardy.barioth.web.id/storage/foto_barang/${rincian.barang!.fotoBarang}',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 239, 223),
        title: const Text('Riwayat Penitipan', style: TextStyle(color: Colors.black87)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.black87)))
              : Container(
                  color: Colors.grey[100], // Latar belakang abu-abu muda
                  child: _rincianList.isEmpty
                      ? const Center(
                          child: Text('Tidak ada riwayat penitipan.',
                              style: TextStyle(color: Colors.black87)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12.0),
                          itemCount: _rincianList.length,
                          itemBuilder: (context, index) {
                            final rincian = _rincianList[index];
                            return Card(
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Bagian Kiri (9/12)
                                    Expanded(
                                      flex: 9,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID PENITIPAN: ${rincian.idPenitipan ?? "Tidak tersedia"}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tanggal Masuk: ${_formatDate(rincian.penitipan?.tanggalMasuk)}',
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                          Text(
                                            'Tanggal Akhir: ${_formatDate(rincian.tanggalAkhir)}',
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            height: 16,
                                          ),
                                          Text(
                                            'Nama Barang: ${rincian.barang?.namaBarang ?? "Tidak tersedia"}',
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                          Text(
                                            'Harga Barang: ${_formatCurrency(rincian.barang?.hargaBarang)}',
                                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                                          ),
                                          Text(
                                            'Status: ${rincian.statusPenitipan ?? "Tidak tersedia"}',
                                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton(
                                            onPressed: () => _showDetailDialog(context, rincian),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(255, 4, 121, 2),
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                            ),
                                            child: const Text(
                                              'Lihat Detail',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Bagian Kanan (3/12)
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: rincian.barang?.fotoBarang != null
                                            ? Image.network(
                                                'https://laraveledwardy.barioth.web.id/storage/foto_barang/${rincian.barang!.fotoBarang}',
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    const Icon(Icons.image_not_supported, size: 80),
                                              )
                                            : const Icon(Icons.image_not_supported, size: 80),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}