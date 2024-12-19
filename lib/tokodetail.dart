import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart.dart';

class TokoDetail extends StatefulWidget {
  final int tokoId;
  final String namaToko;
  final String deskripsi;
  final String estimasiWaktu;

  const TokoDetail({
    super.key,
    required this.tokoId,
    required this.namaToko,
    required this.deskripsi,
    required this.estimasiWaktu,
  });

  @override
  _TokoDetailState createState() => _TokoDetailState();
}

class _TokoDetailState extends State<TokoDetail> {
  final Map<String, int> _cart = {};
  int _totalItems = 0;
  int _totalPrice = 0;
  List<dynamic> _menus = [];
  String? _gambarUrl;

  @override
  void initState() {
    super.initState();
    _loadMenuData();
    _loadTokoData();
  }

  Future<void> _loadMenuData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/tokos/${widget.tokoId}/menus/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _menus = json.decode(response.body);
      });
    }
  }

  Future<void> _loadTokoData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/tokos/${widget.tokoId}'),
    );

    if (response.statusCode == 200) {
      final tokoData = json.decode(response.body);
      setState(() {
        _gambarUrl = tokoData['gambar'];
      });
    }
  }

  void _addItem(String title, int price) {
    setState(() {
      if (_cart.containsKey(title)) {
        _cart[title] = _cart[title]! + 1;
      } else {
        _cart[title] = 1;
      }
      _totalItems++;
      _totalPrice += price;
    });
  }

  void _removeItem(String title, int price) {
    setState(() {
      if (_cart.containsKey(title) && _cart[title]! > 0) {
        _cart[title] = _cart[title]! - 1;
        _totalItems--;
        _totalPrice -= price;
        if (_cart[title] == 0) {
          _cart.remove(title);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaToko),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImageHeader(),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Menu dan Varian',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ..._menus.map((menu) => _buildMenuItem(
                imagePath: 'http://10.0.2.2:8000${menu['gambar']}',
                title: menu['nama_menu'],
                price: menu['harga'],
                menuId: menu['id'],
                ulasanTotal: menu['ulasan_total'],
                ulasanBintang: menu['ulasan_bintang'],
              )),
              const SizedBox(height: 80), // Add space below the list
            ],
          ),
        ),
      ),
      floatingActionButton: _totalItems > 0
        ? Container(
          width: MediaQuery.of(context).size.width - 50,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(
                  cart: _cart,
                  totalPrice: _totalPrice,
                  menuPrices: _menus.map((menu) => {
                    'title': menu['nama_menu'],
                    'price': menu['harga'],
                    'menu_id': menu['id'],
                  }).toList(),
                  namaToko: widget.namaToko, // Pass the namaToko
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: const Color(0xFF00385D),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Keranjang', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 10),
              Text('$_totalItems item', style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 10),
              Text('Rp $_totalPrice', style: const TextStyle(color: Colors.white)),
            ],
          ),
          ),
        )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: _gambarUrl != null
              ? Image.network(
                  'http://10.0.2.2:8000$_gambarUrl',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : const Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.namaToko,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(widget.deskripsi,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    SizedBox(width: 5),
                    Text('4.7'),
                  ],
                ),
                const SizedBox(height: 5),
                Text('Estimasi Waktu: ${widget.estimasiWaktu}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String imagePath,
    required String title,
    required int price,
    required int menuId,
    required int ulasanTotal,
    required double ulasanBintang,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 50,
                  offset: Offset(0, 30),
                ),
              ],
            ),
            child: Image.network(
              imagePath, // Ganti URL gambar
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    const SizedBox(width: 5),
                    Text('${ulasanBintang.toStringAsFixed(1)} ($ulasanTotal Ulasan)'),
                  ],
                ),
                Text('Rp $price', style: const TextStyle(fontSize: 16)),
                _cart.containsKey(title) && _cart[title]! > 0
                    ? Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _removeItem(title, price),
                          ),
                          Text('${_cart[title]}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _addItem(title, price),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () => _addItem(title, price),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00385D),
                          minimumSize: const Size(120, 30),
                        ),
                        child: const Text('Pesan', style: TextStyle(color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
