import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_post_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final AdminServices _adminServices = AdminServices();
  List<Product>? products = [];
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() {
    _adminServices.getAllProducts(context).then((value) {
      setState(() {
        products = value;
      });
    });
  }

  void deleteProduct({required Product product, required int index}) {
    _adminServices.deleteProduct(context: context, product: product);
    setState(() {
      products!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: products!.isNotEmpty
          ? GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                var product = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140.0,
                      child: SingleProduct(product),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteProduct(product: product, index: index);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )
          : const Center(
              child: Text('No products'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddPostScreen.routeName),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
