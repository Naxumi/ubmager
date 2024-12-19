import 'package:flutter/material.dart';

class Notif extends StatelessWidget {
  const Notif({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove the back icon button
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Pesanan Selesai
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Pesanan Selesai'),
              subtitle: const Text('Pesanan Anda telah sampai. Selamat menikmati!'),
              trailing: const Text(
                '10m lalu',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Aksi saat notifikasi diklik
              },
            ),
          ),
          const SizedBox(height: 10),

          // Promo Makanan
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.orange),
              title: const Text('Promo Spesial Makanan'),
              subtitle: const Text('Diskon 50% untuk pembelian hari ini!'),
              trailing: const Text(
                '1h lalu',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Aksi saat notifikasi diklik
              },
            ),
          ),
          const SizedBox(height: 10),

          // Pesanan Baru
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.blue),
              title: const Text('Pesanan Baru'),
              subtitle: const Text('Pesanan Anda sedang diproses.'),
              trailing: const Text(
                '2h lalu',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Aksi saat notifikasi diklik
              },
            ),
          ),
          const SizedBox(height: 10),

          // Notifikasi Umum
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.grey),
              title: const Text('Notifikasi Umum'),
              subtitle: const Text('Tetap ikuti informasi terbaru dari kami.'),
              trailing: const Text(
                '1d lalu',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Aksi saat notifikasi diklik
              },
            ),
          ),
        ],
      ),
    );
  }
}
