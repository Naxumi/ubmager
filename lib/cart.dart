import 'package:flutter/material.dart';
import 'payment.dart';

class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final int totalPrice;

  const CartPage({super.key, required this.cart, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayam Geprek Sumber Sari'), // Change to store name
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
                    builder: (context) =>
                        PaymentPage(cart: cart, totalPrice: totalPrice),
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
    // Define the prices for each item
    switch (title) {
      case 'Nasi Goreng Spesial':
        return 25000;
      case 'Mie Ayam Bakso':
        return 20000;
      case 'Es Teh Manis':
        return 5000;
      default:
        return 0;
    }
  }
}
