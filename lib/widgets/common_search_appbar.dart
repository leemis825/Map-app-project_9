import 'package:flutter/material.dart';

class CommonSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onHelpPressed;
  final VoidCallback onLocationPressed;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const CommonSearchAppBar({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onHelpPressed,
    required this.onLocationPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF004098),
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white60),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: onHelpPressed,
        ),
        IconButton(
          icon: const Icon(Icons.my_location, color: Colors.white),
          onPressed: onLocationPressed,
        ),
      ],
    );
  }
}
