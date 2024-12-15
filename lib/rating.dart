import 'package:flutter/material.dart';

class RatingUlasan extends StatelessWidget {
  const RatingUlasan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating dan Ulasan Pengguna'),
      ),
      body: Column(
        children: [
          // Tab Penilaian
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFB0D0E6), // Warna latar atas
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Penilaian Saya',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Belum Dinilai',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                // Ulasan Makanan 1
                buildReviewTile(
                  username: 'Ripqi Nopal',
                  dateTime: '17 - 08 - 1945 10.00',
                  variant: 'Pedas Pro Max',
                  review: 'Wenak pol gesss............',
                  imagePath: 'assets/food1.png',
                  buttonLabel: 'Beli Lagi',
                  restaurantName: 'Ayam Geprek Mas Faiz | Pedas Pol En...',
                ),
                const Divider(),
                // Ulasan Driver
                ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/driver.png'),
                  ),
                  title: const Text(
                    'Driver',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                      const Text('Driver cepat...'),
                    ],
                  ),
                ),
                const Divider(),
                // Ulasan Makanan 2
                buildReviewTile(
                  username: 'Ripqi Nopal',
                  dateTime: '30 - 09 - 1965 10.00',
                  variant: 'Full Cream',
                  review: 'Segar seperti menjadi ironman',
                  imagePath: 'assets/food2.png',
                  buttonLabel: 'Beli Lagi',
                  restaurantName: 'Ayam Geprek Mas Faiz | Pedas Pol En...',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewTile({
    required String username,
    required String dateTime,
    required String variant,
    required String review,
    required String imagePath,
    required String buttonLabel,
    required String restaurantName,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Ulasan
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/profile_picture.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Detail Ulasan
          Text(
            '$dateTime | Varian : $variant',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              // Gambar Makanan
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              // Review dan Tombol
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
