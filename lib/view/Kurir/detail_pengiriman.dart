import 'package:flutter/material.dart';
import 'package:reusemart/entity/pemesanan.dart';

class DetailPengiriman extends StatelessWidget {
  const DetailPengiriman({super.key, required this.pemesanan});
  final Pemesanan pemesanan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Pengiriman',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 239, 223),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'ID Pemesanan: ${pemesanan.idPemesanan}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 121, 2),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Pengiriman:',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 121, 2),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${pemesanan.tanggalPengiriman}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: pemesanan.statusPengiriman == 'Transaksi Selesai'
                                    ? Color.fromARGB(255, 4, 121, 2)
                                    : Colors.yellow,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                pemesanan.statusPengiriman == 'Transaksi Selesai'
                                    ? 'Selesai'
                                    : 'Menunggu',
                                style: TextStyle(
                                  color: pemesanan.statusPengiriman == 'Transaksi Selesai'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Alamat Penerima',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                          Text(
                            'Nama Penerima: ${pemesanan.alamat?.namaPenerima}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Nomor Telepon: ${pemesanan.alamat?.noHp}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Alamat Penerima: ${pemesanan.alamat?.namaAlamat}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Barang',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                          ...pemesanan.rincianPemesanan?.map(
                            (rincian) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      'https://laraveledwardy.barioth.web.id/storage/foto_barang/${rincian.barang?.fotoBarang}',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${rincian.barang?.namaBarang}',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          'Berat: ${rincian.barang?.beratBarang} Kg',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          '${rincian.barang?.deskripsiBarang}',
                                          style: const TextStyle(fontSize: 14),
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          'Rp ${rincian.barang?.hargaBarang}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).toList() ??
                          [
                            const Text(
                              'Tidak ada rincian barang.',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}