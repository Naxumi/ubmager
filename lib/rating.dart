import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Profil(),
    );
  }
}

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/food2.jpg'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Animex',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'animex@student.ub.id',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rating dan Ulasan Pengguna'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RatingUlasan()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Pengaturan Akun'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
