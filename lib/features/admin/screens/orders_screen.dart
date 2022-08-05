import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/models/order_model.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final adminServices = AdminServices();
  List<Order> orders = [];
  @override
  void initState() {
    super.initState();
    adminServices.getAllOrders(context).then((value) {
      setState(() {
        orders = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? const Center(
            child: Text('No orders exist yet.'),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              var order = orders[index];
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  OrderDetailsScreen.routeName,
                  arguments: order,
                ),
                child: SizedBox(
                  height: 140.0,
                  child: SingleProduct(order.items[0].product),
                ),
              );
            },
            itemCount: orders.length,
          );
  }
}
