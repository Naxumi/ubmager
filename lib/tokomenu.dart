import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import the image picker package
import 'menuedit.dart'; // Import the edit page

class TokoMenuManage extends StatefulWidget {
  const TokoMenuManage({super.key});

  @override
  _TokoMenuManageState createState() => _TokoMenuManageState();
}

class _TokoMenuManageState extends State<TokoMenuManage> {
  int? _tokoId;
  List<dynamic> _menus = [];

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

      // Print status code for debugging
      // Print response body for debugging

      if (response.statusCode == 200) {
        final List<dynamic> tokoList = json.decode(response.body);
        final tokoData = tokoList.firstWhere(
            (toko) => toko['user_id'] == userId,
            orElse: () => null);

        if (tokoData != null) {
          setState(() {
            _tokoId = tokoData['id'];
          });
          _loadMenuData(tokoData['id']);
        }
      }
    }
  }

  Future<void> _loadMenuData(int tokoId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/tokos/$tokoId/menus/'),
    );

    // Print status code for debugging
    // Print response body for debugging

    if (response.statusCode == 200) {
      setState(() {
        _menus = json.decode(response.body);
      });
    }
  }

  Future<void> _deleteMenu(int menuId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/menus/$menuId'),
    );

    // Print status code for debugging
    // Print response body for debugging

    if (response.statusCode == 200) {
      setState(() {
        _menus.removeWhere((menu) => menu['id'] == menuId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Gagal menghapus menu. Status code: ${response.statusCode}')),
      );
    }
  }

  Future<void> _addMenu(
      int tokoId, String namaMenu, int harga, XFile? gambar) async {
    final url = 'http://10.0.2.2:8000/tokos/$tokoId/menus/?nama_menu=$namaMenu&harga=$harga&ulasan_total=0&ulasan_bintang=0';

    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (gambar != null) {
      request.files.add(await http.MultipartFile.fromPath('file', gambar.path));
    }

    final response = await request.send();

    // Print status code for debugging
    final responseData = await response.stream.bytesToString();
    // Print response body for debugging

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu berhasil ditambahkan')),
      );
      _loadMenuData(tokoId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan menu. Status code: ${response.statusCode}\nResponse: $responseData')),
      );
    }
  }

  void _showAddMenuBottomSheet() {
    final TextEditingController namaMenuController = TextEditingController();
    final TextEditingController hargaController = TextEditingController();
    XFile? pickedFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaMenuController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: const Text('Unggah Gambar'),
                  ),
                  const SizedBox(width: 10),
                  if (pickedFile != null)
                    const Text('Gambar diunggah',
                        style: TextStyle(color: Colors.green)),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_tokoId != null) {
                    _addMenu(_tokoId!, namaMenuController.text,
                        int.parse(hargaController.text), pickedFile);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Tambah Menu'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Menu'),
        centerTitle: true,
      ),
      body: _tokoId == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _menus.length,
              itemBuilder: (context, index) {
                final menu = _menus[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading:
                        Image.network('http://10.0.2.2:8000${menu['gambar']}'),
                    title: Text(menu['nama_menu']),
                    subtitle: Text('Harga: ${menu['harga']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MenuEdit(menuId: menu['id']),
                              ),
                            );
                            if (result == true) {
                              _loadMenuData(_tokoId!);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteMenu(menu['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
