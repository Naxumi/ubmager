import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  final Map<String, int> cart;

  const RatingPage({super.key, required this.cart});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  // Simpan rating per produk
  Map<String, double> ratings = {};
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inisialisasi rating produk ke 0
    for (var key in widget.cart.keys) {
      ratings[key] = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beri Penilaian Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  String productTitle = widget.cart.keys.elementAt(index);
                  return _buildRatingSection(productTitle);
                },
              ),
            ),
            const SizedBox(height: 10),

            // Kolom Ulasan
            const Text(
              'Tulis Ulasan Anda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis ulasan mengenai produk...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Kirim Penilaian
            ElevatedButton(
              onPressed: () {
                _showThankYouDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00385D),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Kirim Penilaian',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian rating produk
  Widget _buildRatingSection(String productTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () {
                setState(() {
                  ratings[productTitle] = (index + 1).toDouble();
                });
              },
              icon: Icon(
                Icons.star,
                color: index < (ratings[productTitle] ?? 0)
                    ? Colors.amber
                    : Colors.grey,
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Dialog Ucapan Terima Kasih
  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terima Kasih!'),
        content: const Text('Penilaian Anda telah dikirim.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.popUntil(context,
                  (route) => route.isFirst); // Kembali ke halaman utama
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
