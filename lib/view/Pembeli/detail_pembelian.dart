import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reusemart/entity/pemesanan.dart';

class DetailPembelianPage extends StatelessWidget {
  final Pemesanan pemesanan;

  const DetailPembelianPage({Key? key, required this.pemesanan}) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return 'Belum diterima';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 239, 223),
        title: const Text('Detail Pembelian'),
        leading: const BackButton(),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Pembelian',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 94, 94, 94),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ID Order:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 94, 94, 94),
                            ),
                          ),
                          Text(
                            pemesanan.idPemesanan ?? 'N/A',
                            style: const TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Metode Pengiriman:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 94, 94, 94),
                            ),
                          ),
                          Text(
                            pemesanan.metodePengiriman ?? 'N/A',
                            style: const TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Alamat Pengiriman:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 94, 94, 94),
                            ),
                          ),
                          Text(
                            pemesanan.alamat != null
                                  ? '${pemesanan.alamat!.namaAlamat}'
                                  : 'N/A',
                            style: const TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Batas Pengambilan:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 94, 94, 94),
                            ),
                          ),
                          Text(
                            _formatDate(pemesanan.batasPengambilan),
                            style: const TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status Pengambilan:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 94, 94, 94),
                            ),
                          ),
                          Text(
                            pemesanan.statusPengiriman ?? 'N/A',
                            style: const TextStyle(color: Color.fromARGB(255, 94, 94, 94)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Lunas'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFFFFEFDF), // Sesuai dengan gradient akhir
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Pembelian',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...pemesanan.rincianPemesanan?.map((rincian) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Placeholder untuk gambar
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rincian.barang?.namaBarang ?? 'Nama barang tidak tersedia',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Rp ${rincian.hargaBarang?.toStringAsFixed(0) ?? '0'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList() ??
                          [const Text('Tidak ada rincian pembelian')],
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal (2 items)'),
                          Text('Rp ${pemesanan.totalHarga?.toStringAsFixed(0) ?? '0'}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Biaya Pengiriman'),
                          Text('Rp ${pemesanan.ongkos?.toStringAsFixed(0) ?? '0'}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Diskon Poin'),
                          Text(
                            '-Rp ${(pemesanan.poinDigunakan != null ? pemesanan.poinDigunakan! * 100 : 0).toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp ${pemesanan.totalHarga?.toStringAsFixed(0) ?? '0'}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Poin didapatkan'),
                          Text('+${pemesanan.poinDidapatkan ?? 0} poin'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Poin digunakan'),
                          Text('-${pemesanan.poinDigunakan ?? 0} poin'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}