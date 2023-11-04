import 'package:flutter/material.dart';

class SquareFile extends StatelessWidget {
  final void Function()? onTap;
  final String imagePath;
  const SquareFile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200]),
        child: Image.asset(
          imagePath,
          height: 14,
        ),
      ),
    );
  }
}
