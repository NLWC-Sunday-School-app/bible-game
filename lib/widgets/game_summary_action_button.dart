
import 'package:flutter/material.dart';
class GameSummaryActionButton extends StatelessWidget {
  const GameSummaryActionButton({Key? key, required this.size, required this.icon, required this.shapeColor, required this.onTap}) : super(key: key);
  final double size;
  final Widget icon;
  final Color shapeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
          ),
          child: Container(
            padding: EdgeInsets.all(size),
            decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: shapeColor
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
