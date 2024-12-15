import 'package:flutter/material.dart';

class PengaturanAkun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Akun'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Bagian Profil
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Ubah Profil'),
            subtitle: Text('Nama, foto, dan informasi lainnya'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Ubah Profil
            },
          ),
          Divider(),

          // Bagian Keamanan
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Keamanan'),
            subtitle: Text('Ganti kata sandi atau atur keamanan'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Keamanan
            },
          ),
          Divider(),

          // Bagian Notifikasi
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifikasi'),
            subtitle: Text('Atur preferensi notifikasi'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Notifikasi
            },
          ),
          Divider(),

          // Bagian Bahasa
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Bahasa'),
            subtitle: Text('Pilih bahasa aplikasi'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan bahasa
            },
          ),
          Divider(),

          // Tombol Keluar
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('Keluar', style: TextStyle(color: Colors.red)),
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
  runApp(MaterialApp(
    home: PengaturanAkun(),
  ));
}
