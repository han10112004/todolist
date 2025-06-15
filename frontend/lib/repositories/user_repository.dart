import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/models/user_model.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['user'] != null) {
        return UserModel.fromJson(json['user']);
      } else {
        throw Exception('Phản hồi không có trường "data".');
      }
    } else {
      final json = jsonDecode(response.body);
      final message = json['message'] ?? 'Sai email hoặc mật khẩu';
      throw Exception(message);
    }
  }

}
