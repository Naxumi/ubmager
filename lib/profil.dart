import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'bantuan.dart';
import 'pendapatan.dart';
import 'pengaturanumum.dart';
import 'pengaturanakun.dart';
import 'rating.dart';
import 'history.dart';
>>>>>>> 9a3d9103f6d9e2041108b4fabe54a2e09a60a9e5

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
<<<<<<< HEAD
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Pengaturan Akun'),
            onTap: () {
              // Navigate to Profile settings or any other page if needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            onTap: () {
              // Navigate to Notification settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Bantuan'),
            onTap: () {
              // Navigate to Help page
            },
          ),
=======
          // Bagian atas dengan gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0072FF), Color(0xFF00C6FF)], // Gradasi biru
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 150),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Foto Profil
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                          'images/food1.jpg'), // Ganti dengan gambar Anda
                    ),
                    // Icon Edit di kanan atas
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Tambahkan aksi edit di sini
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          iconSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ehek Ehek',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Cihuy@student.ub.id',
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
                  leading: const Icon(Icons.security),
                  title: const Text('Pengaturan Akun'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PengaturanAkun()),
                    );
                  },
                ),
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
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Pendapatan'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PendapatanPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Riwayat Order'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan Umum'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PengaturanUmum()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Bantuan'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BantuanPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
>>>>>>> 9a3d9103f6d9e2041108b4fabe54a2e09a60a9e5
        ],
      ),
    );
  }
}
