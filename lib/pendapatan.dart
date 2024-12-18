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
  int? _userId;
  double _totalPendapatan = 0.0;

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
      double totalPendapatan = 0.0;
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
              detail['user_id'] = transaction['user_id'];
              totalPendapatan += ((detail['harga_per_item'] * detail['jumlah']) as num).toDouble();
            }
          }
        }
      }
      setState(() {
        _transactions = transactions..sort((a, b) => DateTime.parse(b['tanggal_transaksi']).compareTo(DateTime.parse(a['tanggal_transaksi'])));
        _totalPendapatan = totalPendapatan;
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
                final date = DateTime.parse(transaction['tanggal_transaksi']);
                final formattedDate = '${date.day}-${date.month}-${date.year}';
                final totalHarga = transaction['details']
                    .fold(0.0, (sum, detail) => sum + ((detail['harga_per_item'] * detail['jumlah']) as num).toDouble());
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
                              builder: (context) => PendapatanDetailPage(transaction: transaction),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'http://10.0.2.2:8000${toko['gambar']}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(toko['nama_toko']),
                          trailing: Text('Rp$totalHarga'),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
