import 'package:flutter/material.dart';

class Notif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove the back icon button
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Pesanan Selesai
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Pesanan Selesai'),
              subtitle: Text('Pesanan Anda telah sampai. Selamat menikmati!'),
              trailing: Text(
                '10m lalu',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Aksi saat notifikasi diklik
              },
            ),
          ),
          SizedBox(height: 10),

          // Promo Makanan
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.local_offer, color: Colors.orange),
              title: Text('Promo Spesial Makanan'),
              subtitle: Text('Diskon 50% untuk pembelian hari ini!'),
              trailing: Text(
                '1h lalu',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Aksi saat notifikasi diklik
              },
            ),
          ),
          SizedBox(height: 10),

          // Pesanan Baru
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.fastfood, color: Colors.blue),
              title: Text('Pesanan Baru'),
              subtitle: Text('Pesanan Anda sedang diproses.'),
              trailing: Text(
                '2h lalu',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                // Aksi saat notifikasi diklik
              },
            ),
          ),
          SizedBox(height: 10),

          // Notifikasi Umum
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.grey),
              title: Text('Notifikasi Umum'),
              subtitle: Text('Tetap ikuti informasi terbaru dari kami.'),
              trailing: Text(
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
