import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MenuEdit extends StatefulWidget {
  final int menuId;

  const MenuEdit({super.key, required this.menuId});

  @override
  _MenuEditState createState() => _MenuEditState();
}

class _MenuEditState extends State<MenuEdit> {
  final TextEditingController _namaMenuController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _ulasanTotalController = TextEditingController();
  final TextEditingController _ulasanBintangController = TextEditingController();
  String? _gambarUrl;
  String? _oldGambarUrl;
  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/menus/${widget.menuId}'),
    );

    if (response.statusCode == 200) {
      final menuData = json.decode(response.body);
      setState(() {
        _namaMenuController.text = menuData['nama_menu'];
        _hargaController.text = menuData['harga'].toString();
        _ulasanTotalController.text = menuData['ulasan_total'].toString();
        _ulasanBintangController.text = menuData['ulasan_bintang'].toString();
        _gambarUrl = menuData['gambar'];
        _oldGambarUrl = menuData['gambar'];
      });
    }
  }

  Future<void> _updateMenu() async {
    final url = 'http://10.0.2.2:8000/menus/${widget.menuId}?nama_menu=${_namaMenuController.text}&harga=${_hargaController.text}';

    final request = http.MultipartRequest('PUT', Uri.parse(url));

    request.fields['nama_menu'] = _namaMenuController.text;
    request.fields['harga'] = _hargaController.text;

    if (_pickedFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', _pickedFile!.path));
    } else if (_gambarUrl != null) {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000$_gambarUrl'));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempFile = File('${Directory.systemTemp.path}/temp_image.jpg');
        await tempFile.writeAsBytes(bytes);
        request.files.add(await http.MultipartFile.fromPath('file', tempFile.path));
      }
    }

    // Debug prints to show request details
    print('Request URL: $url');
    print('Request Method: ${request.method}');
    print('Request Headers: ${request.headers}');
    print('Request Fields: ${request.fields}');
    print('Request Files: ${request.files.map((file) => file.filename).toList()}');

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu berhasil diperbarui')),
      );
      Navigator.pop(context, true);

      // Delete the old image after updating
      if (_oldGambarUrl != null) {
        final fileUrl = _oldGambarUrl!.replaceFirst('/uploads/', '');
        await http.delete(Uri.parse('http://10.0.2.2:8000/upload/?file_url=$fileUrl'));
      }
    } else {
      final responseData = await response.stream.bytesToString();
      print('Failed to update menu. Status code: ${response.statusCode}');
      print('Response body: $responseData');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui menu. Status code: ${response.statusCode}\nResponse: $responseData')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    _pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      setState(() {
        _gambarUrl = _pickedFile!.path;
      });
    }
  }

  Future<bool> _checkImageExists(String url) async {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaMenuController,
              decoration: const InputDecoration(
                labelText: 'Nama Menu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hargaController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ulasanTotalController,
              decoration: const InputDecoration(
                labelText: 'Ulasan Total',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ulasanBintangController,
              decoration: const InputDecoration(
                labelText: 'Ulasan Bintang',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Unggah Gambar'),
                ),
                const SizedBox(width: 10),
                if (_gambarUrl != null)
                  Text('Gambar diunggah', style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 10),
            if (_gambarUrl != null)
              FutureBuilder<bool>(
                future: _checkImageExists('http://10.0.2.2:8000$_gambarUrl'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || !snapshot.data!) {
                    return _pickedFile != null
                        ? Image.file(File(_pickedFile!.path))
                        : const Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity);
                  } else {
                    return Image.network('http://10.0.2.2:8000$_gambarUrl');
                  }
                },
              )
            else
              const Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateMenu,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
