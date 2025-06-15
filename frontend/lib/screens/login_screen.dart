import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/repositories/user_repository.dart';
import 'package:todolist/screens/todo_screen.dart';
import 'package:todolist/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  final UserService _userService = UserService(
    UserRepository(baseUrl: 'http://10.0.2.2:8080'),
  );

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ email và mật khẩu.");
      return;
    }

    try {
      final success = await _userService.login(email, password);

      if (success) {
        // In user_id ra terminal
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');
        print('Đăng nhập thành công. user_id: $userId');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TodoScreen()),
        );
      } else {
        _showMessage("Email hoặc mật khẩu không đúng.");
        print('Đăng nhập thất bại.');
      }
    } catch (e) {
      _showMessage("Đã xảy ra lỗi: ${e.toString().replaceAll('Exception: ', '')}");
      print('Lỗi khi đăng nhập: $e');
    }
  }


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.lock, size: 80, color: Colors.blueGrey),
                const SizedBox(height: 16),
                const Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueGrey,
                  ),
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // TODO: Điều hướng sang trang đăng ký
                    _showMessage("Đi tới trang đăng ký...");
                  },
                  child: const Text("Chưa có tài khoản? Đăng ký"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
