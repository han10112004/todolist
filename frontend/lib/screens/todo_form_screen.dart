import 'dart:async';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoFormScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const TodoFormScreen({super.key, required this.onSubmit});

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _statusId = 3;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<TimeOfDay?> _showCustomTimePicker({
    required BuildContext context,
    required String label,
    required bool Function(TimeOfDay) validator,
    required String errorMessage,
  }) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    String? error;

    return showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: false, // không cho thoát nếu chưa hợp lệ
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(label),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Giờ: "),
                      DropdownButton<int>(
                        value: selectedTime.hour,
                        items: List.generate(24, (index) => DropdownMenuItem(
                          value: index,
                          child: Text(index.toString().padLeft(2, '0')),
                        )),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedTime = TimeOfDay(hour: value, minute: selectedTime.minute));
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      const Text("Phút: "),
                      DropdownButton<int>(
                        value: selectedTime.minute,
                        items: List.generate(60, (index) => DropdownMenuItem(
                          value: index,
                          child: Text(index.toString().padLeft(2, '0')),
                        )),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedTime = TimeOfDay(hour: selectedTime.hour, minute: value));
                          }
                        },
                      ),
                    ],
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(error!, style: const TextStyle(color: Colors.red)),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text("Hủy"),
                ),
                TextButton(
                  onPressed: () {
                    if (validator(selectedTime)) {
                      Navigator.of(context).pop(selectedTime);
                    } else {
                      setState(() => error = errorMessage);
                    }
                  },
                  child: const Text("Chọn"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> _pickStartTime() async {
    final now = TimeOfDay.now();
    final picked = await _showCustomTimePicker(
      context: context,
      label: "Chọn giờ bắt đầu",
      validator: (picked) {
        final nowDate = DateTime.now();
        final pickedDate = DateTime(nowDate.year, nowDate.month, nowDate.day, picked.hour, picked.minute);
        return pickedDate.isAfter(DateTime.now());
      },
      errorMessage: "Giờ bắt đầu phải sau thời gian hiện tại!",
    );

    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final now = DateTime.now();
    final picked = await _showCustomTimePicker(
      context: context,
      label: "Chọn giờ kết thúc",
      validator: (picked) {
        if (_startTime == null) return false;
        final start = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
        final end = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        return end.isAfter(start) && end.isAfter(now);
      },
      errorMessage: "Giờ kết thúc phải sau giờ bắt đầu và hiện tại!",
    );

    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }



  Future<void> _handleSubmit() async {
  if (_formKey.currentState!.validate()) {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy user_id. Vui lòng đăng nhập lại.")),
      );
      return;
    }

    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn thời gian bắt đầu và kết thúc")),
      );
      return;
    }

    final now = DateTime.now();
    final startDateTime = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    final endDateTime = DateTime(now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

    // 🔒 RÀNG BUỘC THỜI GIAN
    if (startDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thời gian bắt đầu phải lớn hơn thời gian hiện tại")),
      );
      return;
    }

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thời gian kết thúc phải lớn hơn thời gian bắt đầu")),
      );
      return;
    }

    if (endDateTime.isBefore(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thời gian kết thúc phải lớn hơn thời gian hiện tại")),
      );
      return;
    }

    final data = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'statusId': _statusId,
      'userId': userId,
      'startTime': startDateTime.toIso8601String(),
      'endTime': endDateTime.toIso8601String(),
    };

    widget.onSubmit(data);
    Navigator.pop(context);
  }
}


  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat("dd/MM/yyyy HH:mm:ss").format(_currentTime);

    return Scaffold(
      appBar: AppBar(title: const Text("Thêm Công Việc")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("Thời gian: $formattedTime"),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Tiêu đề"),
                    validator: (value) => value!.isEmpty ? "Tiêu đề không được để trống" : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Mô tả"),
                    validator: (value) => value!.isEmpty ? "Mô tả không được để trống" : null,
                  ),

                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(6, 166, 161, 1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: _pickStartTime,
                          child: Text(_startTime != null
                              ? 'Giờ bắt đầu: ${_startTime!.format(context)}'
                              : 'Chọn giờ bắt đầu'),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(6, 166, 161, 1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton(
                          onPressed: _pickEndTime,
                          child: Text(_endTime != null
                              ? 'Giờ kết thúc: ${_endTime!.format(context)}'
                              : 'Chọn giờ kết thúc'),
                        ),
                      )

                    ],
                  ),
                ],
              ),

              // const SizedBox(height: 200),
              GestureDetector(
                onTap: () => _handleSubmit(),
                child: Container(
                  height: 50,
                  width: 370,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(6, 166, 161, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Thêm công việc",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
