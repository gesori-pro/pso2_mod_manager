import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ItemIconsCarousel extends StatelessWidget {
  const ItemIconsCarousel({
    super.key,
    required this.iconPaths,
  });

  final List<String> iconPaths;

  @override
  Widget build(BuildContext context) {
    List<Widget> imgWidgetList = [];
    for (var path in iconPaths) {
      imgWidgetList.add(Image.file(
        File(path),
        filterQuality: FilterQuality.none,
        fit: BoxFit.cover,
      ));
    }

    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 2.0,
          viewportFraction: 1,
          disableCenter: true,
          //enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          reverse: true,
          enableInfiniteScroll: true,
          autoPlayInterval: const Duration(seconds: 2),
          autoPlay: iconPaths.length > 1 ? true : false),
      items: imgWidgetList,
    );
  }
}
