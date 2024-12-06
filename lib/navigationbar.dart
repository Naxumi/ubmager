// navigationbar.dart
import 'package:flutter/material.dart';

class ReusableNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  ReusableNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Color.fromARGB(255, 0, 56, 93), // Update background color
      selectedItemColor: Colors.white, // Color when selected
      unselectedItemColor: Colors.grey[400], // Color when unselected
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
