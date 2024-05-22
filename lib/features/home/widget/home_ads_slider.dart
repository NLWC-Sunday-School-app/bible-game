import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAdsSlider extends StatelessWidget {
  const HomeAdsSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return  CarouselSlider.builder(
        itemCount: 15,
        itemBuilder: (BuildContext context, int itemIndex,
            int pageViewIndex) =>
            Container(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10.r),
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl:
                    'https://res.cloudinary.com/dd3hfa9ug/image/upload/v1711721070/WhatsApp_Image_2024-03-29_at_12.19.50_qshwth.jpg',
                    placeholder: (context, String url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, String url,
                        dynamic error) =>
                    const Icon(Icons.error),
                  ),
                ),
              ),
            ),
        options: CarouselOptions(
          height: 400,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration:
          Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
        ));
  }
}
