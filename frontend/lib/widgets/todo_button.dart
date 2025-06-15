import 'package:flutter/material.dart';
import '../screens/todo_form_screen.dart';

class TodoButton extends StatelessWidget {
  final Function(Map<String, dynamic>) onAdd;

  const TodoButton({super.key, required this.onAdd});

  void _navigateToForm(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => TodoFormScreen(onSubmit: onAdd),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0); // Từ phải qua
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _navigateToForm(context),
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
    );
  }
}
