import 'package:flutter/material.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key, 
    required this.automaticallyImplyLeading,
    required this.title,
    this.actions,
  });
  
  final bool automaticallyImplyLeading;
  final String title;
  final List<Widget>? actions;

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
          Text(widget.title, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      titleTextStyle: const TextStyle(color: Colors.black),
      backgroundColor: const Color.fromRGBO(241, 248, 255, 1),
      actions: widget.actions ?? const [],
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      foregroundColor: Colors.black,
    );
  }
}
