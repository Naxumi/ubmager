import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade200,
        title: const Text(
          'Riwayat Order',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar
          Container(
            color: Colors.lightBlue.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.fastfood, color: Colors.black),
                  label: const Text(
                    'Food & Drinks ▼',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today, color: Colors.black),
                  label: const Text(
                    'Tanggal ▼',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // History List
          Expanded(
            child: ListView(
              children: [
                // Kamis, 20 Sep 2024
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Kamis, 20 Sep 2024',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildHistoryItem('Martabak Manis', 'Jalan Kalasan Barat No.22',
                    'images/food6.jpg', 'Rp.35.000'),
                _buildHistoryItem('Es Teh Anget', 'Jalan Bengawan Bali No.13',
                    'images/food6.jpg', 'Rp.5.000'),
                _buildHistoryItem(
                    'Mochi Gemoy Mas Iz',
                    'Jalan Raya Kemochian, Tang..',
                    'images/food6.jpg',
                    'Rp.35.000'),
                const SizedBox(height: 10),

                // Jumat, 21 Sep 2024
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Jumat, 21 Sep 2024',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildHistoryItem(
                    'Mie Ayam Special',
                    'Jalan Suryat Gang.XXI No.9',
                    'images/food6.jpg',
                    'Rp.133.000'),
                _buildHistoryItem(
                    'Burger Low Budget',
                    'Jalan Dieng Atas Blok Kem...',
                    'images/food6.jpg',
                    'Rp.3.000'),
                _buildHistoryItem(
                    'Piscok Special | 4pcs',
                    'Jalan Ambaturin, Penaconcy',
                    'images/food6.jpg',
                    'Rp.10.000'),
                const SizedBox(height: 10),

                // Minggu, 23 Sep 2024
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Minggu, 23 Sep 2024',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildHistoryItem('Paket Hemat 3', 'Jalan Bersama dirimu',
                    'images/food6.jpg', 'Rp.3.000'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Item Riwayat
  Widget _buildHistoryItem(
      String title, String subtitle, String imagePath, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          // Detail Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Harga
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
