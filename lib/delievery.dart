import 'package:flutter/material.dart';
import 'ratingafterpayment.dart';

class DeliveryPage extends StatelessWidget {
  final Map<String, int> cart;
  final int totalPrice;

  const DeliveryPage({super.key, required this.cart, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proses Pengantaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Center(
              child: Column(
                children: [
                  Icon(Icons.delivery_dining,
                      size: 80, color: Color(0xFF00385D)),
                  SizedBox(height: 10),
                  Text(
                    'Pesanan Sedang Diantar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Estimasi Tiba: 20 - 30 Menit',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status Pengiriman
            const Text(
              'Status Pengiriman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatusStep('Pesanan Diproses', true),
            _buildStatusStep('Pesanan Dikirim', true),
            _buildStatusStep('Pesanan Sedang Diantar', true),
            _buildStatusStep('Pesanan Telah Tiba', false),
            const SizedBox(height: 20),

            const Divider(),

            // Ringkasan Pesanan
            const Text(
              'Detail Pesanan',
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

            // Total Harga
            const Divider(),
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

            // Tombol Selesai
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingPage(cart: cart),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00385D),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Selesai',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Status Step
  Widget _buildStatusStep(String title, bool isCompleted) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCompleted ? const Color(0xFF00385D) : Colors.grey,
        child: Icon(
          isCompleted ? Icons.check : Icons.radio_button_unchecked,
          color: Colors.white,
        ),
      ),
      title: Text(title),
    );
  }

  // Fungsi harga produk
  int _getItemPrice(String title) {
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
