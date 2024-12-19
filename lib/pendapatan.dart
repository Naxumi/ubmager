import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pendapatan_detail.dart';

class PendapatanPage extends StatefulWidget {
  const PendapatanPage({super.key});

  @override
  _PendapatanPageState createState() => _PendapatanPageState();
}

class _PendapatanPageState extends State<PendapatanPage> {
  List<dynamic> _transactions = [];
  int? _tokoId;
  double _totalPendapatan = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTokoData();
  }

  Future<void> _loadTokoData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session_data');
    if (sessionData != null) {
      final userData = json.decode(sessionData)['user_data'];
      final userId = userData['id'];

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/tokos/?skip=0&limit=9999'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> tokoList = json.decode(response.body);
        final tokoData = tokoList.firstWhere((toko) => toko['user_id'] == userId, orElse: () => null);

        if (tokoData != null) {
          setState(() {
            _tokoId = tokoData['id'];
          });
          _loadTransactionHistory(tokoData['id']);
        }
      }
    }
  }

  Future<void> _loadTransactionHistory(int tokoId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/tokos/$tokoId/transactions'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final transactions = data['transaction_history'] ?? [];
      double totalPendapatan = 0.0;
      for (var transaction in transactions) {
        totalPendapatan += transaction['total_purchasement'] ?? 0.0;
      }
      setState(() {
        _transactions = transactions;
        _totalPendapatan = totalPendapatan;
      });
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendapatan'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Pendapatan
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Pendapatan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp $_totalPendapatan',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 76, 132, 175),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Riwayat Pendapatan
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Riwayat Pendapatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                final userName = transaction['user_name'] ?? 'Unknown User';
                final totalPurchasement = transaction['total_purchasement'] ?? 0.0;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendapatanDetailPage(transaction: transaction),
                      ),
                    );
                  },
                  child: _buildHistoryItem(
                    userName,
                    'http://10.0.2.2:8000/images/user.png', // Placeholder image
                    'Rp.$totalPurchasement',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Item Riwayat
  Widget _buildHistoryItem(String title, String imagePath, String price) {
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
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.account_circle, size: 50, color: Colors.grey);
              },
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
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
