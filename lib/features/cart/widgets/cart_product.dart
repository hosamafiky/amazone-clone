import 'package:amazon_clone/features/cart/services/cart_services.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct(this.index, {Key? key}) : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final productDetailsServices = ProductDetailsServices();
  final cartServices = CartServices();
  void increaseQuantity(Product product) {
    productDetailsServices.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product) {
    cartServices.deleteFromCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart![widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];
    return Column(
      children: [
        Container(
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
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => decreaseQuantity(product),
                      child: Container(
                        width: 35.0,
                        height: 32.0,
                        alignment: Alignment.center,
                        child: const Icon(Icons.remove, size: 18.0),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Container(
                        width: 35.0,
                        height: 32.0,
                        alignment: Alignment.center,
                        child: Text(quantity.toString()),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => increaseQuantity(product),
                      child: Container(
                        width: 35.0,
                        height: 32.0,
                        alignment: Alignment.center,
                        child: const Icon(Icons.add, size: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
