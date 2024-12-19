import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Pusat Bantuan
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.blue),
            title: const Text('Pusat Bantuan'),
            subtitle: const Text('Cari solusi untuk masalah umum'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Pusat Bantuan
            },
          ),
          const Divider(),

          // Hubungi Kami
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: const Text('Hubungi Kami'),
            subtitle: const Text('Bantuan lebih lanjut melalui telepon atau email'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Hubungi Kami
            },
          ),
          const Divider(),

          // FAQ
          ListTile(
            leading: const Icon(Icons.question_answer, color: Colors.orange),
            title: const Text('FAQ'),
            subtitle: const Text('Pertanyaan yang sering diajukan'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman FAQ
            },
          ),
          const Divider(),

          // Kebijakan Privasi
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.purple),
            title: const Text('Kebijakan Privasi'),
            subtitle: const Text('Informasi tentang kebijakan privasi kami'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Kebijakan Privasi
            },
          ),
          const Divider(),

          // Ketentuan Layanan
          ListTile(
            leading: const Icon(Icons.article, color: Colors.red),
            title: const Text('Ketentuan Layanan'),
            subtitle: const Text('Baca ketentuan dan aturan penggunaan'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Ketentuan Layanan
            },
          ),
        ],
      ),
    );
  }
}
