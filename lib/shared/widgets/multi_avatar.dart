import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/image_routes.dart';
import '../utils/multiavatar_generator.dart';

class AvatarWidget extends StatefulWidget {
  final String seed;
  final double width;
  final double height;
  const AvatarWidget({super.key, required this.seed, required this.width, required this.height});

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  late MultiavatarGenerator generator;
  String? avatarSvg;



  @override
  void initState() {
    super.initState();
    generator = MultiavatarGenerator();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    String svg = await generator.generateAvatar(widget.seed);
    setState(() {
      avatarSvg = svg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return avatarSvg == null
        ? Image.asset(ProductImageRoutes.defaultAvatar, width: 50.w,)
        : SvgPicture.string(avatarSvg!, width: widget.width, height: widget.height);
  }
}
