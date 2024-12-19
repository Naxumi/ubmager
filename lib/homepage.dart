import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'navigationbar.dart';
import 'profil.dart';
import 'tokodetail.dart';
import 'notif.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titip Makan & Antar Jemput',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        '/home': (context) => const Homepage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  Future<List<dynamic>>? _tokosFuture;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _tokosFuture = _loadTokoData();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('session_data')) {
      _showLoginRequiredDialog();
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to be logged in to access this page.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> _loadTokoData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/tokos/?skip=0&limit=9999'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tokos');
    }
  }

  // Daftar halaman yang akan ditampilkan berdasarkan menu
  final List<Widget> _pages = [
    const HomePageContent(),
    const Notif(),
    const Profil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ReusableNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final _HomepageState? homepageState = context.findAncestorStateOfType<_HomepageState>();

    return Container(
      color: const Color(0xFFF4F8FA),
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari makanaaaaan...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF00385D),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF00385D),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF00385D),
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 150,
                  child: FutureBuilder<List<dynamic>>(
                    future: homepageState?._tokosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No tokos available'));
                      } else {
                        final randomTokos = (snapshot.data!..shuffle()).take(3).toList();
                        return PageView(
                          children: randomTokos.map((toko) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TokoDetail(
                                      tokoId: toko['id'],
                                      namaToko: toko['nama_toko'],
                                      deskripsi: toko['deskripsi'],
                                      estimasiWaktu: toko['estimasi_waktu'],
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  'http://10.0.2.2:8000${toko['gambar']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1, color: Colors.black),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(130, 40),
                            backgroundColor: const Color(0xFF00385D),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Titip Makan',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(130, 40),
                            backgroundColor: const Color(0xFF006F8E),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Antar Jemput',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<dynamic>>(
                  future: homepageState?._tokosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No tokos available');
                    } else {
                      final tokos = snapshot.data!;
                      return Column(
                        children: <Widget>[
                          LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = 3;
                              if (constraints.maxWidth < 600) {
                                crossAxisCount = 3;
                              } else if (constraints.maxWidth < 400) {
                                crossAxisCount = 1;
                              }
                              return GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: crossAxisCount,
                                children: List.generate(tokos.length, (index) {
                                  final toko = tokos[index];
                                  return Column(
                                    children: <Widget>[
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TokoDetail(
                                                  tokoId: toko['id'],
                                                  namaToko: toko['nama_toko'],
                                                  deskripsi: toko['deskripsi'],
                                                  estimasiWaktu: toko['estimasi_waktu'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Image.network(
                                                'http://10.0.2.2:8000${toko['gambar']}',
                                                height: 150,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Flexible(
                                        child: Text(
                                          toko['nama_toko'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
