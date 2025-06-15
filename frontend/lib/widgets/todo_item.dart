import 'package:flutter/material.dart';
import '../models/todo_item_model.dart';

class TodoItem extends StatelessWidget {
  final int index;
  final TodoItemModel item;
  final Function(int, bool?) onChanged;
  final Function(int) onDelete;
  final Function(int, String) onUpdate;

  const TodoItem({
    super.key,
    required this.index,
    required this.item,
    required this.onChanged,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.red; // Mặc định là đỏ

    final now = DateTime.now();
    if (item.startTime != null && item.endTime != null) {
      if (now.isBefore(item.endTime!) && now.isAfter(item.startTime!)) {
        borderColor = Colors.yellow; // Đang tiến hành
      } else if (now.isAfter(item.endTime!)) {
        borderColor = Colors.green; // Đã hoàn thành
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isChecked,
          onChanged: (value) => onChanged(index, value),
        ),
        title: Text(item.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showUpdateDialog(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final TextEditingController _editController = TextEditingController(text: item.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật công việc'),
        content: TextField(
          controller: _editController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nội dung mới'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final newText = _editController.text.trim();
              if (newText.isNotEmpty) {
                onUpdate(item.id, newText);
              }
              Navigator.pop(context);
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc chắn muốn xóa công việc này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(index);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }
}
