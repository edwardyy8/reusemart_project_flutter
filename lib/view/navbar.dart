import 'package:flutter/material.dart';

import 'package:reusemart/view/home_page.dart';
import 'package:reusemart/view/Kurir/profile_kurir.dart';
import 'package:reusemart/view/Kurir/tugas_pengiriman.dart';



class NavBar extends StatefulWidget {
  final int selectedIndex;
  final int indextab;
  final String userType;

  const NavBar({super.key, this.selectedIndex = 0, this.indextab = 0, required this.userType});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  int indextab = 0;

  @override
  void initState(){
    super.initState();
    _selectedIndex = widget.selectedIndex;
    indextab = widget.indextab;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _getPages() {
    switch (widget.userType) {
      case 'pembeli':
        return [HomePage(), HomePage(), HomePage()];
      case 'penitip':
        return [HomePage(), HomePage(), HomePage()];
      case 'Kurir':
        return [HomePage(), TugasPengiriman(), ProfileKurir()];
      case 'Hunter':
        return [HomePage(), HomePage(), HomePage()];
      default:
        return [HomePage(), HomePage()];
    }
  }

  List<BottomNavigationBarItem> _getNavItems() {
    switch (widget.userType) {
      case 'pembeli':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      case 'penitip':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Penitipan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      case 'Kurir':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tugas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      case 'Hunter':
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Komisi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ];
      default:
        return [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
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