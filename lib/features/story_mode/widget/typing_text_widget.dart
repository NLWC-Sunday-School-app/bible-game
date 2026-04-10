import 'package:flutter/material.dart';

class TypingTextWidget extends StatefulWidget {
  const TypingTextWidget({
    super.key,
    required this.text,
    this.charsPerSecond = 40,
    this.onComplete,
    this.style,
  });

  final String text;
  final int charsPerSecond;
  final VoidCallback? onComplete;
  final TextStyle? style;

  @override
  State<TypingTextWidget> createState() => _TypingTextWidgetState();
}

class _TypingTextWidgetState extends State<TypingTextWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    final duration = Duration(
      milliseconds: (widget.text.length / widget.charsPerSecond * 1000).round(),
    );

    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _completeTyping() {
    if (!_controller.isCompleted) {
      _controller.forward(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleText = widget.text.substring(
      0,
      (_controller.value * widget.text.length).round(),
    );

    return GestureDetector(
      onTap: _completeTyping,
      behavior: HitTestBehavior.opaque,
      child: Text(
        visibleText,
        style: widget.style,
      ),
    );
  }
}
