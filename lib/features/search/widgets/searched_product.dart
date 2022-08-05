import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic totalRating = 0;
    for (var element in product.rating!) {
      totalRating += element.rating;
    }
    dynamic averageRating = 0;

    averageRating = totalRating / product.rating!.length;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ProductDetailsScreen.routeName,
        arguments: product,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: [
            Image.network(
              product.images[0],
              width: 135.0,
              height: 135.0,
              fit: BoxFit.fitHeight,
            ),
            Column(
              children: [
                Container(
                  width: 235.0,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    product.name,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 235.0,
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: RatingStars(rating: averageRating.toDouble()),
                ),
                Container(
                  width: 235.0,
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Text(
                    '\$${product.price}',
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 235.0,
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text('Eligible for FREE shipping'),
                ),
                Container(
                  width: 235.0,
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: const Text(
                    'In Stock',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
