import 'package:flutter/material.dart';
import 'package:reusemart/client/user_client.dart';
import 'package:reusemart/entity/barang.dart';
import 'package:reusemart/entity/kategori.dart';
import 'package:reusemart/view/login_page.dart';
import 'package:reusemart/view/detail_barang.dart';
import 'package:reusemart/view/pembeli/klaim_merchandise.dart';
import 'package:reusemart/view/kategori_drawer.dart';
import 'package:reusemart/view/top_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Barang> _allBarangs = [];
  List<Barang> _filteredBarangs = [];
  List<Kategori> _allKategoris = [];
  int? _selectedKategoriId;
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBarangs();
    _loadKategori();
  }

  void onHomeTapped() {
    setState(() {
      _selectedKategoriId = null;
      _searchQuery = '';
    });
    _loadBarangs();
  }

  Future<void> _loadBarangs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<dynamic> rawData = await UserClient.getAllBarangs();
      List<Barang> listBarang = rawData.map((e) => Barang.fromJson(e)).toList();

      setState(() {
        _allBarangs = listBarang;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading barangs: $e');
    }
  }

  Future<void> _loadKategori() async {
    final kategoris = await UserClient.getAllKategoris();
    setState(() {
      _allKategoris = kategoris;
    });
  }

  void _applyFilter() {
    List<Barang> filtered = _allBarangs;

    if (_selectedKategoriId != null) {
      filtered = filtered
          .where((barang) =>
              barang.idKategori == _selectedKategoriId)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((barang) =>
              barang.namaBarang?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
          .toList();
    }

    setState(() {
      _filteredBarangs = filtered;
    });
  }

  void _onKategoriSelected(int idKategori) {
    Navigator.of(context).pop();
    setState(() {
      _selectedKategoriId = idKategori;
      _applyFilter();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilter();
    });
  }

  // void _clearFilter() {
  //   setState(() {
  //     _selectedKategoriId = null;
  //     _searchQuery = '';
  //     _filteredBarangs = List.from(_allBarangs);
  //   });
  // }

  Future<void> _confirmLogout() async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi Logout'),
      content: const Text('Apakah Anda yakin ingin logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

  if (shouldLogout == true) {
      await _onLogout();
    }
  }

  Future<void> _onLogout() async {
  try {
    await Future.delayed(const Duration(seconds: 1));

    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  } catch (e) {
    print('Logout error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavbar(
        onSearch: _onSearchChanged,
        searchQuery: _searchQuery,
      ),
      drawer: KategoriDrawer(
        onKategoriSelected: _onKategoriSelected,
        onLogout: _confirmLogout,
      ),
      body: _isLoading
    ? const Center(child: CircularProgressIndicator())
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedKategoriId != null) ...[
              Container(
                width: double.infinity,
                color: Color.fromARGB(255, 238, 237, 237),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'KATEGORI → ${_allKategoris.firstWhere(
                    (k) => k.idKategori == _selectedKategoriId,
                    orElse: () => Kategori(namaKategori: 'Tidak diketahui'),
                  ).namaKategori ?? 'Tidak diketahui'}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'PRODUK TERKAIT',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Text('Dapatkan barang ini sebelum kehabisan!'),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: _filteredBarangs.length,
                itemBuilder: (context, index) {
                  final barang = _filteredBarangs[index];
                  return GestureDetector(
                    onTap: () {
                      if (barang.idBarang != null) {
                        print('Navigasi ke detail barang dengan ID: ${barang.idBarang}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailBarangPage(idBarang: barang.idBarang!.toString()),
                          ),
                        );
                      } else {
                        print('Barang tidak memiliki ID!');
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.network(
                                'http://192.168.88.116:8000/api/foto-barang/${barang.fotoBarang}',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              barang.namaBarang ?? 'Tanpa nama',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
