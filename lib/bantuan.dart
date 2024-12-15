import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bantuan'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Pusat Bantuan
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.blue),
            title: Text('Pusat Bantuan'),
            subtitle: Text('Cari solusi untuk masalah umum'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Pusat Bantuan
            },
          ),
          Divider(),

          // Hubungi Kami
          ListTile(
            leading: Icon(Icons.phone, color: Colors.green),
            title: Text('Hubungi Kami'),
            subtitle: Text('Bantuan lebih lanjut melalui telepon atau email'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Hubungi Kami
            },
          ),
          Divider(),

          // FAQ
          ListTile(
            leading: Icon(Icons.question_answer, color: Colors.orange),
            title: Text('FAQ'),
            subtitle: Text('Pertanyaan yang sering diajukan'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman FAQ
            },
          ),
          Divider(),

          // Kebijakan Privasi
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.purple),
            title: Text('Kebijakan Privasi'),
            subtitle: Text('Informasi tentang kebijakan privasi kami'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Kebijakan Privasi
            },
          ),
          Divider(),

          // Ketentuan Layanan
          ListTile(
            leading: Icon(Icons.article, color: Colors.red),
            title: Text('Ketentuan Layanan'),
            subtitle: Text('Baca ketentuan dan aturan penggunaan'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigasi ke halaman Ketentuan Layanan
            },
          ),
        ],
      ),
    );
  }
}
