import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingPage extends StatefulWidget {
  final Map<String, int> cart;
  final List<Map<String, dynamic>> menuPrices;

  const RatingPage({super.key, required this.cart, required this.menuPrices});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  Map<String, double> ratings = {};
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var key in widget.cart.keys) {
      ratings[key] = 0.0;
    }
  }

  Future<void> _submitRatings() async {
    for (var entry in ratings.entries) {
      final menuTitle = entry.key;
      final rating = entry.value;
      final amountBought = widget.cart[menuTitle] ?? 0;

      // Fetch menu ID based on the title
      final menuId = _getMenuIdByTitle(menuTitle);
      if (menuId != null) {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/menus/$menuId/ulasan'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'ulasan_bintang': rating,
            'ulasan_total': amountBought,
          }),
        );

        // Debug prints to show response details

        if (response.statusCode != 200) {
        }
      } else {
      }
    }
  }

  int? _getMenuIdByTitle(String title) {
    final menu = widget.menuPrices.firstWhere((menu) => menu['title'] == title, orElse: () => {'menu_id': 0});
    return menu['menu_id'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beri Penilaian Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  String productTitle = widget.cart.keys.elementAt(index);
                  return _buildRatingSection(productTitle);
                },
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _submitRatings();
                _showThankYouDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00385D),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Kirim Penilaian',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(String productTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () {
                setState(() {
                  ratings[productTitle] = (index + 1).toDouble();
                });
              },
              icon: Icon(
                Icons.star,
                color: index < (ratings[productTitle] ?? 0)
                    ? Colors.amber
                    : Colors.grey,
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terima Kasih!'),
        content: const Text('Penilaian Anda telah dikirim.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
