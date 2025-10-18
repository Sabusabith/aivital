import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SendButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54),
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.white24, Colors.white24],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.white24,
          //     offset: const Offset(0, 4),
          //     blurRadius: 8,
          //   ),
          // ],
        ),
        child: const Center(
          child: Icon(Icons.send, color: Colors.lightBlue, size: 28),
        ),
      ),
    );
  }
}
