import 'package:flutter/material.dart';

class PengaturanUmum extends StatelessWidget {
  const PengaturanUmum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Umum'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Tema Aplikasi
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Tema Aplikasi'),
            subtitle: const Text('Atur tema terang atau gelap'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan tema
            },
          ),
          const Divider(),

          // Bahasa
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

          // Penyimpanan
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Penyimpanan'),
            subtitle: const Text('Kelola ruang penyimpanan'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan penyimpanan
            },
          ),
          const Divider(),

          // Privasi
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privasi'),
            subtitle: const Text('Atur preferensi privasi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman pengaturan privasi
            },
          ),
          const Divider(),

          // Tentang Aplikasi
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Tentang Aplikasi'),
            subtitle: const Text('Informasi tentang aplikasi ini'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
  runApp(const MaterialApp(
    home: PengaturanUmum(),
  ));
}
