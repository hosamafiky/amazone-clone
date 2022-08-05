import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/services/search_services.dart';
import 'package:amazon_clone/features/search/widgets/searched_product.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  final String searchQuery;
  const SearchScreen(this.searchQuery, {Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchServices _searchServices = SearchServices();
  List<Product>? searchedProducts = [];
  @override
  void initState() {
    super.initState();
    fetchSearchData(widget.searchQuery);
  }

  void fetchSearchData(String query) {
    _searchServices
        .fetchSearchProducts(context: context, query: query)
        .then((value) {
      setState(() {
        searchedProducts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
                      onFieldSubmitted: fetchSearchData,
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
      ),
      body: searchedProducts == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const AddressBox(),
                const SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var product = searchedProducts![index];
                      return SearchedProduct(product);
                    },
                    itemCount: searchedProducts!.length,
                  ),
                ),
              ],
            ),
    );
  }
}
