import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemSize: 20.0,
      direction: Axis.horizontal,
      rating: rating,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: GlobalVariables.secondaryColor,
      ),
      itemCount: 5,
    );
  }
}
