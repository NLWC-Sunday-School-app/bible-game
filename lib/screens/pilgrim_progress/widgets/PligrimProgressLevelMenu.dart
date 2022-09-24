import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PilgrimProgressLevelMenu extends StatelessWidget {
  final String menuImage;
  final String menuNumber;
  final String menuLabel;
  final bool isLocked;
  final double menuProgressValue;

  const PilgrimProgressLevelMenu({
    Key? key,
    required this.menuImage,
    required this.menuNumber,
    required this.menuLabel,
    required this.isLocked, required this.menuProgressValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    menuImage,
                    width: 90,
                  ),
                   SizedBox(
                    height: 105,
                    width: 105,
                    child: CircularProgressIndicator(
                      value: menuProgressValue,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(220, 240, 158, 1),
                      ),
                      strokeWidth: 5,
                      backgroundColor: const Color.fromRGBO(70, 90, 8, 1),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 7, top: 10),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: AutoSizeText(
                menuNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Color(0xFF362A7A),
                ),
              ),
            ),
            isLocked
                ? Positioned(
                    top: 58,
                    left: 18,
                    child: SvgPicture.asset(
                      'assets/images/pilgrim_levels/padlock.svg',
                      width: 30,
                    ),
                  )
                : const SizedBox()
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, left: 35),
          child: AutoSizeText(
            menuLabel,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
