import 'package:flutter/material.dart';

class PendapatanDetailPage extends StatelessWidget {
  final dynamic transaction;

  const PendapatanDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final userName = transaction['user_name'];
    final totalPurchasement = transaction['total_purchasement'];
    final details = transaction['details'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pendapatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: $userName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Harga: Rp.$totalPurchasement',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Pembelian:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  return ListTile(
                    title: Text(detail['nama_menu']),
                    subtitle: Text('Jumlah: ${detail['quantity']}'),
                    trailing: Text('Rp.${detail['menu_price']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
