import 'package:flutter/material.dart';
import 'package:tugas_api_crypto/views/cryptolist_screen.dart';
import 'package:tugas_api_crypto/views/form_home.dart';

class AppBottomnav extends StatefulWidget {
  const AppBottomnav({super.key});

  @override
  State<AppBottomnav> createState() => _AppBottomnavState();
}

class _AppBottomnavState extends State<AppBottomnav> {
  int _selectedIndex = 0;
  String? selected;

  final List<Widget> _pages = [const HomePage(), const Cryptolistscreen()];

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF7C9A92),
        unselectedItemColor: Colors.blueGrey,
        onTap: _onBottomNavTapped,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Routine',
          ),
        ],
      ),
    );
  }
}
