import 'package:flutter/material.dart';
import 'delivery.dart';

class PaymentPage extends StatelessWidget {
  final Map<String, int> cart;
  final int totalPrice;
  final List<Map<String, dynamic>> menuPrices;
  final List<int> menuId;

  const PaymentPage({
    super.key,
    required this.cart,
    required this.totalPrice,
    required this.menuPrices,
    required this.menuId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  String title = cart.keys.elementAt(index);
                  int quantity = cart[title]!;
                  int itemTotalPrice = quantity * _getItemPrice(title);
                  return ListTile(
                    title: Text(title),
                    subtitle: Text('Jumlah: $quantity'),
                    trailing: Text('Rp $itemTotalPrice'),
                  );
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Harga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp $totalPrice',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPaymentOption('Transfer Bank', Icons.account_balance),
            _buildPaymentOption('E-Wallet', Icons.phone_android),
            _buildPaymentOption('COD (Bayar di Tempat)', Icons.money),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryPage(
                      cart: cart,
                      totalPrice: totalPrice,
                      menuPrices: menuPrices,
                      menuId: menuId,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00385D),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Konfirmasi Pembayaran',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00385D)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Aksi saat metode pembayaran dipilih
      },
    );
  }

  int _getItemPrice(String title) {
    final menu = menuPrices.firstWhere((menu) => menu['title'] == title, orElse: () => {'price': 0});
    return menu['price'];
  }
}
