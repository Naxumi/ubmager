import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'transaction_detail.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> _transactions = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session_data');
    if (sessionData != null) {
      final userData = json.decode(sessionData)['user_data'];
      setState(() {
        _userId = userData['id'];
      });
      _loadTransactionHistory();
    }
  }

  Future<void> _loadTransactionHistory() async {
    if (_userId == null) return;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/transactions/history/$_userId'),
    );

    if (response.statusCode == 200) {
      final transactions = json.decode(response.body);
      for (var transaction in transactions) {
        for (var detail in transaction['details']) {
          final menuResponse = await http.get(
            Uri.parse('http://10.0.2.2:8000/menus/${detail['menu_id']}'),
          );
          if (menuResponse.statusCode == 200) {
            final menuData = json.decode(menuResponse.body);
            final tokoResponse = await http.get(
              Uri.parse('http://10.0.2.2:8000/tokos/${menuData['toko_id']}'),
            );
            if (tokoResponse.statusCode == 200) {
              final tokoData = json.decode(tokoResponse.body);
              detail['nama_toko'] = tokoData['nama_toko'];
              detail['gambar'] = tokoData['gambar'];
            }
          }
        }
      }
      setState(() {
        _transactions = transactions..sort((a, b) => DateTime.parse(b['tanggal_transaksi']).compareTo(DateTime.parse(a['tanggal_transaksi'])));
      });
    } else {
      print('Failed to load transaction history. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade200,
        title: const Text(
          'Riwayat Order',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigasi kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar
          const SizedBox(height: 10),
          // History List
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                final date = DateTime.parse(transaction['tanggal_transaksi']);
                final formattedDate = '${date.day}-${date.month}-${date.year}';
                final totalHarga = transaction['details']
                    .fold(0, (sum, detail) => sum + (detail['harga_per_item'] * detail['jumlah']));
                final toko = transaction['details'].isNotEmpty ? transaction['details'][0] : null;
                final showDate = index == 0 || formattedDate != DateTime.parse(_transactions[index - 1]['tanggal_transaksi']).toString().split(' ')[0];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (toko != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailPage(transaction: transaction),
                            ),
                          );
                        },
                        child: _buildHistoryItem(
                          toko['nama_toko'],
                          'http://10.0.2.2:8000${toko['gambar']}',
                          'Rp.$totalHarga',
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Item Riwayat
  Widget _buildHistoryItem(
      String title, String imagePath, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          // Detail Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Harga
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
