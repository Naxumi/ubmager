import 'package:flutter/material.dart';
import 'dart:async';
import 'navigationbar.dart';

void main() {
  runApp(MyApp());
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Automatic sliding every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Fungsi untuk mengganti halaman
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: const Color(0xFFF4F8FA),
          height: double.infinity,
          width: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(  // Added Scrollable Container
              child: Column(
                children: <Widget>[
                  // Carousel Banner
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari makanaaaaan...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        borderSide: const BorderSide(color: Colors.blue), // Outline color
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: <Widget>[
                            Image.asset('images/banner1.png', fit: BoxFit.cover),
                            Image.asset('images/banner2.png', fit: BoxFit.cover),
                            Image.asset('images/banner3.png', fit: BoxFit.cover),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_left, size: 32, color: Colors.white),
                            onPressed: () {
                              if (_currentPage > 0) {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_right, size: 32, color: Colors.white),
                            onPressed: () {
                              if (_currentPage < 2) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Buttons for "Titip Makan" and "Antar Jemput"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _onItemTapped(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedIndex == 0 ? const Color.fromARGB(255, 0, 56, 93) : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text('Titip Makan', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () => _onItemTapped(1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedIndex == 1 ? const Color.fromARGB(255, 0, 56, 93) : const Color.fromARGB(108, 0, 56, 93),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text('Antar Jemput', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Content based on selected button
                  _selectedIndex == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Gambar Makanan Cards
                            GridView.builder(
                              shrinkWrap: true,  // Allow GridView to adapt to content
                              physics: NeverScrollableScrollPhysics(),  // Disable internal scrolling
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: 6, // Ganti sesuai dengan data makanan
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'images/food${index + 1}.jpg', // Sesuaikan nama gambar
                                          height: 100,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Makanan ${index + 1}'),
                                  ],
                                );
                              },
                            ),
                          ],
                        )
                      : const Center(child: Text('Fitur Antar Jemput')),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ReusableNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
