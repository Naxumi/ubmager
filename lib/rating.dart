import 'package:flutter/material.dart';

class RatingUlasan extends StatelessWidget {
  const RatingUlasan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating dan Ulasan Pengguna'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // Contoh Rating Ulasan
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('images/food2.jpg'),
            ),
            title: const Text('animex'),
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
                const Text('17 - 08 - 1945 10.00 | Varian: Pedas Pro Max'),
                const SizedBox(height: 5),
                const Text('Wenak pol gesss............'),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('images/food3.jpg'),
            ),
            title: const Text('Driver'),
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
        ],
      ),
    );
  }
}
