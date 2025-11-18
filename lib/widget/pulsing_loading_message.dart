import 'package:flutter/material.dart';

class PulsingLoadingMessage extends StatefulWidget {
  final String message;
  const PulsingLoadingMessage({super.key, required this.message});

  @override
  State<PulsingLoadingMessage> createState() => PulsingLoadingMessageState();
}

class PulsingLoadingMessageState extends State<PulsingLoadingMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_animation),
      child: Text(
        widget.message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 36, 149, 255)),
      ),
    );
  }
}