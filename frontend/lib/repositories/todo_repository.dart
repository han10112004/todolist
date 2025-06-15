import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/models/todo_item_model.dart';

class TodoRepository {
  final String baseUrl;

  TodoRepository({required this.baseUrl});

  Future<Map<String, dynamic>> create(
    String title, 
    String description, 
    int statusId, 
    int userId, 
    String startTime,
    String endTime,
  ) async {
    final url = Uri.parse('$baseUrl/api/todos/create');
    final bodyData = {
      'title': title,
      'description': description,
      'statusId': statusId,
      'userId': userId,
      'startTime': startTime, // ✅ chuyển thành String
      'endTime': endTime,     // ✅ chuyển thành String
    };
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return {
          'id': json['id'].toString(),
          'title': json['title'],
          'description': json['description'],
          'startTime': json['startTime'],
          'endTime': json['endTime']
        };
      } else {
        // Log chi tiết lỗi
        print('❌ Lỗi tạo công việc:');
        print('🔹 URL: $url');
        print('🔹 Request body: $bodyData');
        print('🔹 Status code: ${response.statusCode}');
        print('🔹 Response body: ${response.body}');
        throw Exception('Lỗi tạo công việc: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('⚠️ Exception khi gửi yêu cầu tạo công việc: $e');
      print('📄 StackTrace: $stackTrace');
      throw Exception('Không thể kết nối tới server hoặc lỗi không xác định.');
    }
  }

  Future<List<TodoItemModel>> getAll() async {
    final url = Uri.parse('$baseUrl/api/todos/get_all');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      print("Danh sach: $jsonList");
      return jsonList.map((json) => TodoItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Lỗi khi tải danh sách công việc');
    }
  }
  
   Future<Map<String, String>> update(int id, String title, String description, int statusId, int userId) async {
    final url = Uri.parse('$baseUrl/api/todos/update/$id');
    final bodyData = {
      'title': title,
      'description': description,
      'statusId': statusId,
      'userId': userId,
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return {
          'id': json['id'].toString(),
          'title': json['title'],
          'description': json['description'],
          'startTime': json['startTime'],
        };
      } else {
        // Log chi tiết lỗi
        print('❌ Lỗi tạo công việc:');
        print('🔹 URL: $url');
        print('🔹 Request body: $bodyData');
        print('🔹 Status code: ${response.statusCode}');
        print('🔹 Response body: ${response.body}');
        throw Exception('Lỗi tạo công việc: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('⚠️ Exception khi gửi yêu cầu tạo công việc: $e');
      print('📄 StackTrace: $stackTrace');
      throw Exception('Không thể kết nối tới server hoặc lỗi không xác định.');
    }
  }

  Future<void> delete(int id) async {
    final url = Uri.parse('$baseUrl/api/todos/delete/$id');
    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print("Đã xóa");
      return json.decode(response.body);
    } else {
      throw Exception('Lỗi khi tải danh sách công việc');
    }
  }

  Future<void> deleteMany(List<int> ids) async {
    final url = Uri.parse('$baseUrl/api/todos/delete-all');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ids),
    );

    if (response.statusCode == 200) {
      print("Xóa nhiều thành công: ${response.body}");
    } else {
      throw Exception("Lỗi xóa nhiều: ${response.body}");
    }
  }
}
