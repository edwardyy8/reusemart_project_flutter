import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reusemart/client/user_client.dart';
import 'package:reusemart/entity/merchandise.dart';
import 'package:reusemart/view/home_page.dart';
import '../../providers/providers.dart';

class KlaimMerchandise extends ConsumerStatefulWidget {
  const KlaimMerchandise({super.key});

  @override
  ConsumerState<KlaimMerchandise> createState() => _KlaimMerchandiseState();
}

class _KlaimMerchandiseState extends ConsumerState<KlaimMerchandise> {
  List<Merchandise> _allMerchandises = [];
  List<Merchandise> _filteredMerchandises = [];
  String _searchQuery = '';
  bool _isLoading = true;
  int _poinPembeli = 0;

  @override
  void initState() {
    super.initState();
    _loadMerchandises();
    _loadPoin();
  }

  Future<void> _loadPoin() async {
    try {
      final token = await UserNotifier.getAuthToken();
      final response = await UserClient.getPoinPembeli(token!);
      setState(() {
        _poinPembeli = response;
      });
    } catch (e) {
      print('Error memuat poin: $e');
    }
  }

  Future<void> _loadMerchandises() async {
    setState(() => _isLoading = true);
    try {
      List<Merchandise> listMerchandise = await UserClient.getAllMerchandise();
      setState(() {
        _allMerchandises = listMerchandise;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading merchandise: $e');
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    List<Merchandise> filtered = _allMerchandises.where((merch) {
      return merch.namaMerchandise?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
    }).toList();
    setState(() => _filteredMerchandises = filtered);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilter();
    });
  }

  void _showConfirmationDialog(Merchandise merch) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Konfirmasi Klaim"),
        content: Text(
          "Yakin ingin menggunakan ${merch.poinMerchandise ?? 0} poin untuk klaim merchandise ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              final token = await UserNotifier.getAuthToken();
              var result = await UserClient.claimMerchandise(token!, merch.idMerchandise!);
              var statusCode = result['statusCode'];

              await _loadMerchandises();
              await _loadPoin();

              if (!mounted) return;

              if (statusCode == 200 || statusCode == 201) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.leftSlide,
                  headerAnimationLoop: false,
                  dialogType: DialogType.success,
                  showCloseIcon: false,
                  dismissOnTouchOutside: false,
                  title: 'Berhasil!',
                  desc: 'Berhasil klaim merchandise ${merch.namaMerchandise}!',
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.check_circle,
                ).show();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gagal klaim merchandise: ${result['message'] ?? 'Terjadi kesalahan'}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 4, 121, 2),
              foregroundColor: Colors.white,
            ),
            child: const Text("Klaim"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255,255,239,223),
        titleSpacing: 12, 
        title: const Text(
          'Klaim Merchandise',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFEFDF)],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFFEFDF), Color(0xFFFFFFFF)],
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8), 
                          Image.asset(
                            'images/logo/logoreuse.png',
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Poin Loyalitas',
                                style: TextStyle(
                                  color: Color.fromARGB(255,4,121,2),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.monetization_on, color: Color.fromARGB(255, 255, 186, 38)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$_poinPembeli poin',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Cari merchandise...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredMerchandises.length,
                      itemBuilder: (context, index) {
                        final merch = _filteredMerchandises[index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 3,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                                child: Image.network(
                                  'https://laraveledwardy.barioth.web.id/api/foto-merchandise/${merch.fotoMerchandise}',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        merch.namaMerchandise ?? 'Tanpa nama',
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${merch.poinMerchandise ?? 0} Poin',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${merch.stokMerchandise ?? 0} buah',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(255,4,121,2),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          onPressed: () => _showConfirmationDialog(merch),
                                          child: const Text("Klaim"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
