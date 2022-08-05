import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/models/order_model.dart';
import 'package:flutter/material.dart';

class OrdersSection extends StatefulWidget {
  const OrdersSection({Key? key}) : super(key: key);

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  final accountServices = AccountServices();
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    accountServices.getOrders(context: context).then((value) {
      setState(() {
        orders = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15.0),
              child: const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                'See All',
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 170.0,
          child: orders == null || orders!.isEmpty
              ? const Center(
                  child: Text(
                    'There\'re no orders yet\nKeep Shopping',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  itemBuilder: (context, index) {
                    var singleProduct = orders![index].items[0].product;
                    return InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        OrderDetailsScreen.routeName,
                        arguments: orders![index],
                      ),
                      child: SingleProduct(singleProduct),
                    );
                  },
                  itemCount: orders!.length,
                ),
        ),
      ],
    );
  }
}
