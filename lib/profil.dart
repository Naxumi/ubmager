import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login.dart';
import 'bantuan.dart';
import 'pendapatan.dart';
import 'pengaturanumum.dart';
import 'pengaturanakun.dart';
import 'rating.dart';
import 'history.dart';
import 'profiledit.dart';
import 'tokomanage.dart';
import 'tokomenu.dart'; // Import the new page

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  Future<Map<String, dynamic>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session_data');
    if (sessionData != null) {
      return json.decode(sessionData)['user_data'];
    }
    return {};
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_data');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout berhasil')),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading profile data'));
          } else {
            final userData = snapshot.data!;
            return Column(
              children: [
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
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ProfileEdit()),
                                  );
                                  if (result == true) {
                                    setState(() {});
                                  }
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
                      Text(
                        userData['nama'] ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userData['email'] ?? 'Email tidak tersedia',
                        style: const TextStyle(
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
                      // ListTile(
                      //   leading: const Icon(Icons.star),
                      //   title: const Text('Rating dan Ulasan Pengguna'),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const RatingUlasan()),
                      //     );
                      //   },
                      // ),
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
                      if (userData['role'] == 'penjual')
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
                      if (userData['role'] == 'penjual')
                        ListTile(
                          leading: const Icon(Icons.store),
                          title: const Text('Kelola Toko'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TokoManage()),
                            );
                          },
                        ),
                      if (userData['role'] == 'penjual')
                        ListTile(
                          leading: const Icon(Icons.menu_book),
                          title: const Text('Kelola Menu'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TokoMenuManage()),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Keluar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      ),
    );
  }
}
