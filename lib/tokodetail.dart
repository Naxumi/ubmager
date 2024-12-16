import 'package:flutter/material.dart';
import 'cart.dart';

class TokoDetail extends StatefulWidget {
  const TokoDetail({super.key});

  @override
  _TokoDetailState createState() => _TokoDetailState();
}

class _TokoDetailState extends State<TokoDetail> {
  final Map<String, int> _cart = {};
  int _totalItems = 0;
  int _totalPrice = 0;

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
        title: const Text('Toko Detail'),
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
              _buildMenuItem(
                imagePath: 'images/food2.jpg',
                title: 'Nasi Goreng Spesial',
                price: 25000,
              ),
              const SizedBox(height: 10), // Add space between menu items
              _buildMenuItem(
                imagePath: 'images/food3.jpg',
                title: 'Mie Ayam Bakso',
                price: 20000,
              ),
              const SizedBox(height: 10), // Add space between menu items
              _buildMenuItem(
                imagePath: 'images/food4.jpg',
                title: 'Es Teh Manis',
                price: 5000,
              ),
              _buildMenuItem(
                imagePath: 'images/food4.jpg',
                title: 'Es Teh Manis',
                price: 5000,
              ),
              _buildMenuItem(
                imagePath: 'images/food4.jpg',
                title: 'Es Teh Manis',
                price: 5000,
              ),
              _buildMenuItem(
                imagePath: 'images/food4.jpg',
                title: 'Es Teh Manis',
                price: 5000,
              ),
              _buildMenuItem(
                imagePath: 'images/food4.jpg',
                title: 'Es Teh Manis',
                price: 5000,
              ),
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
        MaterialPageRoute(builder: (context) => CartPage(cart: _cart, totalPrice: _totalPrice)),
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
          child: Image.asset(
            'images/food1.jpg', // Ganti dengan URL gambar Anda
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
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
              children: const [
                Text('Ayam Geprek SumberSari',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('Cepat Saji, Aneka Minuman',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    SizedBox(width: 5),
                    Text('4.7'),
                  ],
                ),
                SizedBox(height: 5),
                Text('Delivery: Tiba dalam 15-20 Menit (1.5 Km)',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({required String imagePath, required String title, required int price}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 50,
                  offset: Offset(0, 30),
                ),
              ],
            ),
            child: Image.asset(
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
                  children: const [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    SizedBox(width: 5),
                    Text('4.7 (142 Ulasan)'),
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
                        child: const Text('Pesan', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00385D),
                          minimumSize: const Size(120, 30),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
