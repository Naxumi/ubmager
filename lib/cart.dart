import 'package:flutter/material.dart';
import 'payment.dart';

class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final int totalPrice;
  final List<Map<String, dynamic>> menuPrices;
  final String namaToko; // Add namaToko

  const CartPage({
    super.key,
    required this.cart,
    required this.totalPrice,
    required this.menuPrices,
    required this.namaToko, // Add namaToko
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaToko), // Use namaToko for the app bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  String title = cart.keys.elementAt(index);
                  int quantity = cart[title]!;
                  int itemTotalPrice = quantity * _getItemPrice(title);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF00385D),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(title),
                    subtitle: Text('Total: Rp $itemTotalPrice'),
                    trailing: Text(
                      'Rp $itemTotalPrice',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Rp $totalPrice',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      cart: cart,
                      totalPrice: totalPrice,
                      menuPrices: menuPrices,
                      menuId: _getMenuId().cast<int>(),
                    ),
                  ),
                );
              },
              child: const Text('Pesan Sekarang',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00385D),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getItemPrice(String title) {
    final menu = menuPrices.firstWhere((menu) => menu['title'] == title, orElse: () => {'price': 0});
    return menu['price'];
  }

  List _getMenuId() {
    return cart.keys.map((title) {
      final menu = menuPrices.firstWhere((menu) => menu['title'] == title, orElse: () => {'id': 0});
      return menu['id'] ?? 0;
    }).toList();
  }
}
