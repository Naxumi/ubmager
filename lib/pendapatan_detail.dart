import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PendapatanDetailPage extends StatelessWidget {
  final dynamic transaction;

  const PendapatanDetailPage({super.key, required this.transaction});

  Future<String> _getMenuName(int menuId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/menus/$menuId'));
    if (response.statusCode == 200) {
      final menuData = json.decode(response.body);
      return menuData['nama_menu'];
    } else {
      return 'Unknown Menu';
    }
  }

  Future<String> _getUserName(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/users/$userId'));
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return userData['nama'];
    } else {
      return 'Unknown User';
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(transaction['tanggal_transaksi']);
    final formattedDate = '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}:${date.second}';
    final totalHarga = transaction['details']
        .fold(0, (sum, detail) => sum + (detail['harga_per_item'] * detail['jumlah']));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pendapatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal: $formattedDate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Harga: Rp.$totalHarga',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<String>(
              future: _getUserName(transaction['user_id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading user name...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    'User: ${snapshot.data}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Pembelian:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: transaction['details'].length,
                itemBuilder: (context, index) {
                  final detail = transaction['details'][index];
                  return FutureBuilder<String>(
                    future: _getMenuName(detail['menu_id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Loading...'),
                        );
                      } else if (snapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return ListTile(
                          title: Text(snapshot.data ?? 'Unknown Menu'),
                          subtitle: Text('Jumlah: ${detail['jumlah']}'),
                          trailing: Text('Rp.${detail['harga_per_item']}'),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
