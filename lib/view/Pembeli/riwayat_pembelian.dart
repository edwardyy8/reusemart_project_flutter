import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reusemart/client/pemesanan_client.dart';
import 'package:reusemart/entity/pemesanan.dart';
import 'package:reusemart/view/Pembeli/detail_pembelian.dart'; // Pastikan path ini sesuai
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPembelianPage extends StatefulWidget {
  const RiwayatPembelianPage({Key? key}) : super(key: key);

  @override
  _RiwayatPembelianPageState createState() => _RiwayatPembelianPageState();
}

class _RiwayatPembelianPageState extends State<RiwayatPembelianPage> {
  List<Pemesanan> _pemesananList = [];
  List<Pemesanan> _filteredPemesananList = [];
  bool _isLoading = true;
  String? _errorMessage;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchPemesanan();
  }

  Future<void> _fetchPemesanan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idPembeli =
          prefs.getString('id_pembeli') ?? prefs.getString('user_id');
      String? userType = prefs.getString('user_type');

      if (idPembeli == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'ID Pembeli tidak ditemukan. Silakan login kembali.';
        });
        return;
      }

      if (userType != 'pembeli') {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Fitur ini hanya tersedia untuk pengguna tipe pembeli.';
        });
        return;
      }

      final pemesanan =
          await PemesananClient.getPemesananByIdPembeli(idPembeli);
      setState(() {
        _pemesananList = pemesanan;
        _filteredPemesananList = pemesanan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat riwayat pembelian: $e';
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Belum diterima';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _filterPemesanan() {
    if (_startDate == null || _endDate == null) {
      setState(() {
        _filteredPemesananList = _pemesananList;
      });
      return;
    }

    setState(() {
      _filteredPemesananList = _pemesananList.where((pemesanan) {
        final tanggalPemesanan = pemesanan.tanggalPemesanan;
        final tanggalDiterima = pemesanan.tanggalDiterima;

        // Pesanan masuk jika tanggal_pemesanan atau tanggal_diterima dalam rentang
        bool isPemesananInRange = tanggalPemesanan != null &&
            tanggalPemesanan.isAfter(_startDate!.subtract(Duration(days: 1))) &&
            tanggalPemesanan.isBefore(_endDate!.add(Duration(days: 1)));

        bool isDiterimaInRange = tanggalDiterima != null &&
            tanggalDiterima.isAfter(_startDate!.subtract(Duration(days: 1))) &&
            tanggalDiterima.isBefore(_endDate!.add(Duration(days: 1)));

        return isPemesananInRange || isDiterimaInRange;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _filterPemesanan();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 239, 223),
        title: const Text('Riwayat Pembelian'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFFFEFDF),
                      ],
                      stops: [0.64, 0.85],
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'PILIH PERIODE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14, color: Colors.grey[700]),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          _startDate == null
                                              ? 'Tanggal Mulai'
                                              : _formatDate(_startDate),
                                          style: const TextStyle(fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 14, color: Colors.grey[700]),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          _endDate == null
                                              ? 'Tanggal Selesai'
                                              : _formatDate(_endDate),
                                          style: const TextStyle(fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _filteredPemesananList.isEmpty
                            ? const Center(
                                child: Text(
                                    'Tidak ada riwayat pembelian untuk periode ini.'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: _filteredPemesananList.length,
                                itemBuilder: (context, index) {
                                  final pemesanan =
                                      _filteredPemesananList[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID PEMESANAN: ${pemesanan.idPemesanan}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tanggal Pemesanan: ${_formatDate(pemesanan.tanggalPemesanan)}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            'Tanggal Diterima: ${_formatDate(pemesanan.tanggalDiterima)}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            height: 16,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'BARANG PEMBELIAN:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          if (pemesanan.rincianPemesanan !=
                                                  null &&
                                              pemesanan
                                                  .rincianPemesanan!.isNotEmpty)
                                            ...pemesanan.rincianPemesanan!
                                                .map((rincian) {
                                              return Text(
                                                '- ${rincian.barang?.namaBarang ?? "Nama barang tidak tersedia"}',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              );
                                            }).toList()
                                          else
                                            const Text(
                                              'Tidak ada barang',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1,
                                            height: 16,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Status Pemesanan: ${pemesanan.statusPengiriman}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  final detailPemesanan =
                                                      await PemesananClient
                                                          .getPemesananByIdPemesanan(
                                                              pemesanan
                                                                  .idPemesanan!);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPembelianPage(
                                                              pemesanan:
                                                                  detailPemesanan),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Gagal memuat detail: $e')),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text('Lihat Detail'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
