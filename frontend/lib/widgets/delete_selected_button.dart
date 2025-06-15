import 'package:flutter/material.dart';

class DeleteSelectedButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DeleteSelectedButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete_forever, color: Colors.white),
      label: const Text("Xóa các mục đã chọn", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
    );
  }
}
