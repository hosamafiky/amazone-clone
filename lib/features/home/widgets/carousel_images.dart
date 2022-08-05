import 'package:amazon_clone/constants/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImages extends StatelessWidget {
  const CarouselImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages
          .map((e) => Image.network(
                e,
                height: 200.0,
                fit: BoxFit.cover,
              ))
          .toList(),
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        aspectRatio: 2.0,
        viewportFraction: 1.0,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
