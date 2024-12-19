import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TokoManage extends StatefulWidget {
  const TokoManage({super.key});

  @override
  _TokoManageState createState() => _TokoManageState();
}

class _TokoManageState extends State<TokoManage> {
  final TextEditingController _namaTokoController = TextEditingController();
  final TextEditingController _estimasiWaktuController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _gambarUrl;
  String? _oldGambarUrl;
  int? _userId;
  int? _tokoId;
  XFile? _pickedFile;

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
      _loadTokoData();
    }
  }

  Future<void> _loadTokoData() async {
    if (_userId == null) return;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/tokos/?skip=0&limit=9999'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> tokoList = json.decode(response.body);
      final tokoData = tokoList.firstWhere((toko) => toko['user_id'] == _userId, orElse: () => null);

      if (tokoData != null) {
        setState(() {
          _tokoId = tokoData['id'];
          _namaTokoController.text = tokoData['nama_toko'];
          _estimasiWaktuController.text = tokoData['estimasi_waktu'];
          _deskripsiController.text = tokoData['deskripsi'];
          _gambarUrl = tokoData['gambar'];
          _oldGambarUrl = tokoData['gambar'];
        });
      }
    }
  }

  Future<void> _createOrUpdateToko() async {
    if (_userId == null) return;

    final url = _tokoId == null
        ? 'http://10.0.2.2:8000/tokos/?nama_toko=${_namaTokoController.text}&estimasi_waktu=${_estimasiWaktuController.text}&deskripsi=${_deskripsiController.text}&user_id=$_userId'
        : 'http://10.0.2.2:8000/tokos/$_tokoId?nama_toko=${_namaTokoController.text}&estimasi_waktu=${_estimasiWaktuController.text}&deskripsi=${_deskripsiController.text}&user_id=$_userId';

    final request = http.MultipartRequest(
      _tokoId == null ? 'POST' : 'PUT',
      Uri.parse(url),
    );

    request.fields['nama_toko'] = _namaTokoController.text;
    request.fields['estimasi_waktu'] = _estimasiWaktuController.text;
    request.fields['deskripsi'] = _deskripsiController.text;
    request.fields['user_id'] = _userId.toString();

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

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final updatedTokoData = json.decode(responseData);
      setState(() {
        _gambarUrl = updatedTokoData['gambar'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toko berhasil diperbarui')),
      );
      Navigator.pop(context);

      // Delete the old image after updating
      if (_tokoId != null && _oldGambarUrl != null) {
        final fileUrl = _oldGambarUrl!.replaceFirst('/uploads/', '');
        await http.delete(Uri.parse('http://10.0.2.2:8000/upload/?file_url=$fileUrl'));
      }
    } else {
      final responseData = await response.stream.bytesToString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui toko. Status code: ${response.statusCode}\nResponse: $responseData')),
      );
    }
  }

  Future<void> _deleteToko() async {
    if (_tokoId == null) return;

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/tokos/$_tokoId'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toko berhasil dihapus')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus toko. Status code: ${response.statusCode}\nResponse: ${response.body}')),
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
        title: const Text('Kelola Toko'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaTokoController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _estimasiWaktuController,
              decoration: const InputDecoration(
                labelText: 'Estimasi Waktu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
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
                  const Text('Gambar diunggah', style: TextStyle(color: Colors.green)),
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
              onPressed: _createOrUpdateToko,
              child: const Text('Simpan'),
            ),
            const SizedBox(height: 10),
            if (_tokoId != null)
              ElevatedButton(
                onPressed: _deleteToko,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Hapus'),
              ),
          ],
        ),
      ),
    );
  }
}
