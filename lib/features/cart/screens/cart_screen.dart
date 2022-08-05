import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/cart/widgets/cart_product.dart';
import 'package:amazon_clone/features/cart/widgets/cart_subtotal.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: query,
    );
  }

  void navigateToAddressScreen(double totalAmount) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: totalAmount.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double totalAmount = 0;
    for (var element in user.cart!) {
      totalAmount += element['quantity'] * element['product']['price'];
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 42.0,
                margin: const EdgeInsets.only(left: 15.0),
                child: Material(
                  borderRadius: BorderRadius.circular(7.0),
                  elevation: 1.0,
                  child: TextFormField(
                    onFieldSubmitted: navigateToSearchScreen,
                    decoration: InputDecoration(
                      prefixIcon: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 23.0,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(top: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      ),
                      hintText: 'Search Amazon.in',
                      hintStyle: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              height: 42.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Icon(
                Icons.mic,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: 'Proceed to buy ( ${user.cart!.length} items )',
                onPressed: () => navigateToAddressScreen(totalAmount),
                color: Colors.yellow[600],
                textColor: Colors.black,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(height: 15.0),
            Container(color: Colors.black12, height: 1.0),
            const SizedBox(height: 5.0),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(index);
              },
              itemCount: user.cart!.length,
            ),
          ],
        ),
      ),
    );
  }
}
