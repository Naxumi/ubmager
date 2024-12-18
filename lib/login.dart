import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'daftar.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('session_data')) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _loginUser() async {
    final identifier = _usernameController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/login/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'password',
        'username': identifier,
        'password': password,
        'scope': '',
        'client_id': 'your_client_id',
        'client_secret': 'your_client_secret',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();

      // Fetch user data
      final usersResponse = await http.get(
        Uri.parse('http://10.0.2.2:8000/users/?skip=0&limit=999'),
        headers: {
          'Authorization': 'Bearer ${responseData['access_token']}',
        },
      );

      if (usersResponse.statusCode == 200) {
        final usersData = json.decode(usersResponse.body);
        final user = usersData.firstWhere(
          (user) => user['email'] == identifier || user['nim'] == identifier,
          orElse: () => null,
        );

        if (user != null) {
          // Store access_token and user_data together
          final sessionData = {
            'access_token': responseData['access_token'],
            'user_data': user,
          };
          await prefs.setString('session_data', json.encode(sessionData));

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Login Berhasil'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Login berhasil. Selamat datang!'),
                    const SizedBox(height: 10),
                    Text('Debug Info:\n${json.encode(sessionData)}'),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          _showLoginFailedDialog(response: usersResponse);
        }
      } else {
        _showLoginFailedDialog(response: usersResponse);
      }
    } else if (response.statusCode == 307) {
      final redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        final redirectResponse = await http.post(
          Uri.parse(redirectUrl),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'grant_type': 'password',
            'username': identifier,
            'password': password,
            'scope': '',
            'client_id': 'your_client_id',
            'client_secret': 'your_client_secret',
          },
        );

        if (redirectResponse.statusCode == 200) {
          final responseData = json.decode(redirectResponse.body);
          final prefs = await SharedPreferences.getInstance();

          // Fetch user data
          final usersResponse = await http.get(
            Uri.parse('http://10.0.2.2:8000/users/?skip=0&limit=999'),
            headers: {
              'Authorization': 'Bearer ${responseData['access_token']}',
            },
          );

          if (usersResponse.statusCode == 200) {
            final usersData = json.decode(usersResponse.body);
            final user = usersData.firstWhere(
              (user) => user['email'] == identifier || user['nim'] == identifier,
              orElse: () => null,
            );

            if (user != null) {
              // Store access_token and user_data together
              final sessionData = {
                'access_token': responseData['access_token'],
                'user_data': user,
              };
              await prefs.setString('session_data', json.encode(sessionData));

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Login Berhasil'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Login berhasil. Selamat datang!'),
                        const SizedBox(height: 10),
                        Text('Debug Info:\n${json.encode(sessionData)}'),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              _showLoginFailedDialog(response: usersResponse);
            }
          } else {
            _showLoginFailedDialog(response: usersResponse);
          }
        } else {
          _showLoginFailedDialog(response: redirectResponse);
        }
      }
    } else {
      _showLoginFailedDialog(response: response);
    }
  }

  void _showLoginFailedDialog({required http.Response response}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Gagal'),
          content: Text('Username atau password tidak valid. Status code: ${response.statusCode}\nResponse: ${response.body}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(244, 248, 250, 1),
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Image.asset(
                    'images/logo.png',
                    width: screenWidth * 0.5,
                  ),
                ),
                SizedBox(height: screenHeight * 0.2),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                  endIndent: 355,
                ),
                SizedBox(height: screenHeight * 0.01),
                const Text("Masukkan Alamat email atau NIM"),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username atau NIM',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text("Masukkan password"),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 56, 93),
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                const Center(
                  child: Text(
                    'Lupa Password?',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        endIndent: 10.0,
                        thickness: 1,
                      ),
                    ),
                    Text(
                      "Atau",
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 10.0,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Center(
                    child: Text(
                      'Belum punya Akun? Daftar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UB Mager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const Homepage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
