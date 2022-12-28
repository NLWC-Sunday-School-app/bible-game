import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdsCardShimmer extends StatelessWidget {
  const AdsCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.grey,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 100),
        ),
      ),
    );
  }
}
