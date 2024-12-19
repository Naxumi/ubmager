import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ratingafterorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryPage extends StatelessWidget {
  final Map<String, int> cart;
  final int totalPrice;
  final List<Map<String, dynamic>> menuPrices;

  const DeliveryPage({
    super.key,
    required this.cart,
    required this.totalPrice,
    required this.menuPrices, required List<int> menuId,
  });

  Future<void> _createTransaction(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = json.decode(prefs.getString('session_data')!);
    final userId = sessionData['user_data']['id'];

    final transactionDetails = cart.entries.map((entry) {
      final menuId = _getMenuIdByTitle(entry.key);
      if (menuId == 0) {
        throw Exception('Invalid menu ID for ${entry.key}');
      }
      return {
        'menu_id': menuId,
        'jumlah': entry.value,
        'harga_per_item': _getItemPrice(entry.key),
      };
    }).toList();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/transactions/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'total_harga': totalPrice,
        'status': 'completed',
        'details': transactionDetails,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingPage(cart: cart, menuPrices: menuPrices),
        ),
      );
    } else {
    }
  }

  int _getMenuIdByTitle(String title) {
    final menu = menuPrices.firstWhere((menu) => menu['title'] == title, orElse: () => {'menu_id': 0});
    return menu['menu_id'] ?? 0;
  }

  int _getItemPrice(String title) {
    final menu = menuPrices.firstWhere((menu) => menu['title'] == title, orElse: () => {'price': 0});
    return menu['price'] ?? 0;
  }

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
              onPressed: () => _createTransaction(context),
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
}
