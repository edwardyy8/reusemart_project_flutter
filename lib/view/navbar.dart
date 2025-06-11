import 'package:flutter/material.dart';
import 'package:reusemart/view/Hunter/history_komisi.dart';
import 'package:reusemart/view/Hunter/profile_hunter.dart';
import 'package:reusemart/view/Kurir/profile_kurir.dart';
import 'package:reusemart/view/Kurir/tugas_pengiriman.dart';
import 'package:reusemart/view/Pembeli/klaim_merchandise.dart';
import 'package:reusemart/view/Pembeli/profile_pembeli.dart';
import 'package:reusemart/view/Pembeli/riwayat_pembelian.dart';
import 'package:reusemart/view/Penitip/profile_penitip.dart';
import 'package:reusemart/view/Penitip/riwayat_penitipan.dart';
import 'package:reusemart/view/home_page.dart';
import 'package:reusemart/view/login_page.dart';
import 'package:reusemart/view/show_barang.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  final int indextab;
  final String userType;
  final VoidCallback? onHomeTap;

  const NavBar({super.key, this.selectedIndex = 0, this.indextab = 0, required this.userType, this.onHomeTap});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  int _refreshKey = 0;

  @override
  void initState(){
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      setState(() {
        _refreshKey++;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }

     if (index == 0 && widget.onHomeTap != null) {
      widget.onHomeTap!();
    }
  }

  List<Widget> _getPages() {
    switch (widget.userType) {
      case 'pembeli':
        return [HomePage(key: ValueKey('home-$_refreshKey')), ShowBarang(key: ValueKey('home-$_refreshKey')), RiwayatPembelianPage(), KlaimMerchandise(), ProfilePembeli()];
      case 'penitip':
        return [HomePage(key: ValueKey('home-$_refreshKey')), ShowBarang(key: ValueKey('home-$_refreshKey')), RiwayatPenitipanPage(), ProfilePenitip()];
      case 'Kurir':
        return [HomePage(key: ValueKey('home-$_refreshKey')), ShowBarang(key: ValueKey('home-$_refreshKey')), TugasPengiriman(), ProfileKurir()];
      case 'Hunter':
        return [HomePage(key: ValueKey('home-$_refreshKey')), ShowBarang(key: ValueKey('home-$_refreshKey')), HistoryKomisi(), ProfileHunter()];
      default:
        return [HomePage(key: ValueKey('home-$_refreshKey')), ShowBarang(key: ValueKey('home-$_refreshKey')), LoginPage()];
    }
  }

  List<BottomNavigationBarItem> _getNavItems() {
    switch (widget.userType) {
      case 'pembeli':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Merchandise'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      case 'penitip':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Penitipan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      case 'Kurir':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tugas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      case 'Hunter':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Komisi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      default:
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Login'),
        ];
    }
  }


  @override
  Widget build(BuildContext context) {
    final pages = _getPages();

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _getNavItems(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromARGB(255, 4, 121, 2),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 242, 234, 226),
        
      ),
    );
  }

}