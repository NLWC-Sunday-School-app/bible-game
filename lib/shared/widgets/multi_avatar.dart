import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multiavatar/multiavatar.dart';

import '../constants/image_routes.dart';

/// Displays a unique Multiavatar based on a seed string.
/// Uses a pure Dart implementation — works offline on mobile and web.
class AvatarWidget extends StatelessWidget {
  final String seed;
  final double width;
  final double height;

  const AvatarWidget({
    super.key,
    required this.seed,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (seed.isEmpty) {
      return Image.asset(
        ProductImageRoutes.defaultAvatar,
        width: width,
        height: height,
      );
    }

    final svgCode = multiavatar(seed);

    return SvgPicture.string(
      svgCode,
      width: width,
      height: height,
      placeholderBuilder: (_) => Image.asset(
        ProductImageRoutes.defaultAvatar,
        width: width,
        height: height,
      ),
    );
  }
}
