import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final Product singleProduct;
  const SingleProduct(
    this.singleProduct, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: Container(
          width: 180.0,
          padding: const EdgeInsets.all(10.0),
          child: Image.network(
            singleProduct.images[0],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
