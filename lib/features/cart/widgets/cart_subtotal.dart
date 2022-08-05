import 'package:amazon_clone/provides/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double total = 0;
    for (var element in user.cart!) {
      total += element['quantity'] * element['product']['price'];
    }
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const Text(
            'Subtotal : ',
            style: TextStyle(fontSize: 20.0),
          ),
          Text(
            '\$$total',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
