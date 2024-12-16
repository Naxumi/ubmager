import 'package:flutter/material.dart';

class ReusableNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const ReusableNavigationBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  _ReusableNavigationBarState createState() => _ReusableNavigationBarState();
}

class _ReusableNavigationBarState extends State<ReusableNavigationBar> {
  int pageIndex = 0;

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF00385D),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
                widget.onItemTapped(pageIndex);
              });
            },
            icon: pageIndex == 0
                ? const Icon(Icons.home_filled, color: Colors.white, size: 35)
                : const Icon(Icons.home_outlined, color: Colors.white, size: 35),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
                widget.onItemTapped(pageIndex);
              });
            },
            icon: pageIndex == 1
                ? const Icon(Icons.notifications, color: Colors.white, size: 35)
                : const Icon(Icons.notifications_outlined, color: Colors.white, size: 35),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
                widget.onItemTapped(pageIndex);
              });
            },
            icon: pageIndex == 2
                ? const Icon(Icons.person, color: Colors.white, size: 35)
                : const Icon(Icons.person_outline, color: Colors.white, size: 35),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMyNavBar(context);
  }
}
