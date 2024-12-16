import 'package:flutter/material.dart';

class PengaturanUmum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Umum'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Tema Aplikasi
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Tema Aplikasi'),
            subtitle: Text('Atur tema terang atau gelap'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan tema
            },
          ),
          Divider(),

          // Bahasa
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

          // Penyimpanan
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Penyimpanan'),
            subtitle: Text('Kelola ruang penyimpanan'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan penyimpanan
            },
          ),
          Divider(),

          // Privasi
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privasi'),
            subtitle: Text('Atur preferensi privasi'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan privasi
            },
          ),
          Divider(),

          // Tentang Aplikasi
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang Aplikasi'),
            subtitle: Text('Informasi tentang aplikasi ini'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman tentang aplikasi
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PengaturanUmum(),
  ));
}
