import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo_item_model.dart';
import 'package:todolist/repositories/todo_repository.dart';
import 'package:todolist/screens/login_screen.dart';
import 'package:todolist/services/todo_service.dart';
import 'package:todolist/widgets/delete_selected_button.dart';
import 'package:todolist/widgets/todo_button.dart';
import 'package:todolist/widgets/todo_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late Timer _timer;
  late DateTime _currentTime;
  final TextEditingController _controller = TextEditingController();
  final List<TodoItemModel> _jobList = [];
  bool _selectAll = false;

  late final TodoService _todoService;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _currentTime = DateTime.now());
    });

    _todoService = TodoService(
      TodoRepository(baseUrl: 'http://10.0.2.2:8080'),
    );

    _loadTodos(); // Gọi hàm load dữ liệu
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectAllState() {
    _selectAll = _jobList.isNotEmpty && _jobList.every((item) => item.isChecked);
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var item in _jobList) {
        item.isChecked = _selectAll;
      }
    });
  }

  void _deleteCheckedItems() async {
    try {
      final idsToDelete = _jobList
          .where((item) => item.isChecked)
          .map((item) => item.id)
          .toList();

      await _todoService.deleteMany(idsToDelete);

      setState(() {
        _jobList.removeWhere((item) => idsToDelete.contains(item.id));
        _updateSelectAllState();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xóa các công việc đã chọn")),
      );
    } catch (e) {
      print("Lỗi khi xóa nhiều: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _loadTodos() async {
    try {
      final todos = await _todoService.getAll();
      setState(() {
        _jobList.clear();
        _jobList.addAll(todos);
        _updateSelectAllState();
      });
    } catch (e) {
      print('Lỗi tải công việc: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải công việc: $e')),
        );
      }
    }
  }

  // adđ
  Future<void> _addItem(Map<String, dynamic> data) async {
    try {
      final createdTodo = await _todoService.create(
        data['title'],
        data['description'],
        data['statusId'],
        data['userId'],
        data['startTime'],
        data['endTime']
      );

      setState(() {
        _jobList.add(TodoItemModel(
          id: int.parse(createdTodo['id']!),
          title: createdTodo['title']!,
          description: createdTodo['description']!,
          startTime: DateTime.parse(createdTodo['startTime']!),
          endTime: null,
          isChecked: false,
        ));
        _updateSelectAllState();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm công việc thành công')),
        );
      }
    } catch (e) {
      print("Lỗi khi thêm công việc: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }


  // update
  Future<dynamic> _updateItem(int id, String text) async {
    if (text.trim().isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      print(userId);
      if (userId == null) throw Exception('Không tìm thấy user_id. Vui lòng đăng nhập lại.');

          // Gửi yêu cầu tạo công việc
    final createdTodo = await _todoService.update(
      id,
      text.trim(),
      'Mô tả mặc định',
      1,
      userId,
    );

    setState(() {
      final index = _jobList.indexWhere((item) => item.id == id);
      if (index != -1) {
        _jobList[index] = TodoItemModel(
          id: int.parse(createdTodo['id']!),
          title: createdTodo['title']!,
          description: createdTodo['description']!,
          startTime: DateTime.parse(createdTodo['startTime']!),
          endTime: null,
          isChecked: _jobList[index].isChecked,
        );
        _updateSelectAllState();
      }
    });
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm công việc thành công')),
      );
    } catch (e) {
      print("Lỗi khi thêm công việc: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  void _deleteItem(int index) async {
    final item = _jobList[index];
    try {
      await _todoService.delete(item.id);
      setState(() {
        _jobList.removeAt(index);
        _updateSelectAllState();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa công việc thành công')),
      );
    } catch (e) {
      print("Lỗi xóa công việc: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa: $e')),
        );
      }
    }
  }


  void _toggleItem(int index, bool? value) {
    setState(() {
      _jobList[index].isChecked = value ?? false;
      _updateSelectAllState();
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat("dd/MM/yyyy HH:mm:ss").format(_currentTime);
    bool hasChecked = _jobList.any((item) => item.isChecked);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("To Do List",
                    style: GoogleFonts.dancingScript(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromRGBO(6, 166, 161, 1),
                      decoration: TextDecoration.none,
                    )),
              ),
              Center(child: Text("Ngọc Hân")),
              const SizedBox(height: 40),
              Text("Thời gian: $formattedTime"),
              const SizedBox(height: 10),
              TodoButton(onAdd: _addItem),
              const SizedBox(height: 20),
              const Text("Danh sách công việc:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              if (_jobList.isNotEmpty)
                Row(
                  children: [
                    Checkbox(value: _selectAll, onChanged: _toggleSelectAll),
                    const Text("Chọn tất cả"),
                  ],
                ),
                ..._jobList.asMap().entries.map((entry) {
                  return TodoItem(
                    index: entry.key,
                    item: entry.value,
                    onChanged: _toggleItem,
                    onDelete: _deleteItem,
                    onUpdate: (id, newText) => _updateItem(id, newText),
                  );
                }),
              const SizedBox(height: 20),
              DeleteSelectedButton(onPressed: hasChecked ? _deleteCheckedItems : null),
              IconButton(
                icon: const Icon(Icons.logout, color: Color.fromARGB(255, 21, 206, 71)),
                onPressed: _logout,
                tooltip: "Đăng xuất",
              )
            ],
          ),
        ),
      ),
    );
  }
}
