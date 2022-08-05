import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({Key? key}) : super(key: key);

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? product;
  HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    homeServices.fetchDealOfDayProduct(context: context).then((value) {
      setState(() {
        product = value;
      });
    });
  }

  void navigateToProduct(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailsScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const SizedBox(
            height: 300.0,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: () => navigateToProduct(product!),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 15.0, bottom: 10.0),
                      child: const Text(
                        'Deal of the day',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Image.network(
                      product!.images[0],
                      height: 235.0,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 40.0, 0.0),
                      child: Text(
                        '\$${product!.price}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 40.0, 0.0),
                      child: Text(
                        product!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: product!.images
                            .map(
                              (image) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  image,
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15.0)
                          .copyWith(left: 15.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'See all deals',
                        style: TextStyle(
                          color: Colors.cyan[800],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
