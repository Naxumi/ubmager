import 'package:flutter/material.dart';

class PengaturanAkun extends StatelessWidget {
  const PengaturanAkun({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Bagian Profil
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Ubah Profil'),
            subtitle: const Text('Nama, foto, dan informasi lainnya'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Ubah Profil
            },
          ),
          const Divider(),

          // Bagian Keamanan
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Keamanan'),
            subtitle: const Text('Ganti kata sandi atau atur keamanan'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Keamanan
            },
          ),
          const Divider(),

          // Bagian Notifikasi
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            subtitle: const Text('Atur preferensi notifikasi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Notifikasi
            },
          ),
          const Divider(),

          // Bagian Bahasa
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Bahasa'),
            subtitle: const Text('Pilih bahasa aplikasi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan bahasa
            },
          ),
          const Divider(),

          // Tombol Keluar
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Keluar', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Logika untuk keluar dari akun
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PengaturanAkun(),
  ));
}
