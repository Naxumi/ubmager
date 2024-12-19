import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  String _role = 'user';
  int? _userId;

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
        _namaController.text = userData['nama'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _nimController.text = userData['nim'] ?? '';
        _role = userData['role'] ?? 'user';
        _userId = userData['id'];
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_userId == null) return;

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/users/$_userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nama': _namaController.text,
        'email': _emailController.text,
        'nim': _nimController.text,
        'role': _role,
      }),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = prefs.getString('session_data');
      if (sessionData != null) {
        final userData = json.decode(sessionData)['user_data'];
        userData['nama'] = _namaController.text;
        userData['email'] = _emailController.text;
        userData['nim'] = _nimController.text;
        userData['role'] = _role;
        final updatedSessionData = {
          'access_token': json.decode(sessionData)['access_token'],
          'user_data': userData,
        };
        await prefs.setString('session_data', json.encode(updatedSessionData));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.pop(context, true); // Pass true to indicate data was updated
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil. Status code: ${response.statusCode}\nResponse: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nimController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'user',
                  child: Text('User'),
                ),
                DropdownMenuItem(
                  value: 'penjual',
                  child: Text('Penjual'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
