import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key, 
    required this.automaticallyImplyLeading,
    required this.title,
  });
  
  final bool automaticallyImplyLeading;
  final String title;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      titleTextStyle: const TextStyle(color: Colors.white),
      backgroundColor: Colors.blue,
      actions: const [],
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      foregroundColor: Colors.white,
      elevation: 2,
    );
  }
}
