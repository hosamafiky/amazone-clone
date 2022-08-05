import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = '/add-post';
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final _addPostFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];

  List<File> images = [];

  void pickImages() async {
    var set = await pickFiles();
    setState(() {
      images = set;
    });
  }

  String currentCategory = 'Mobiles';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _addPostFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images
                            .map((e) => Image.file(
                                  e,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ))
                            .toList(),
                        options: CarouselOptions(
                          height: 150.0,
                          aspectRatio: 2.0,
                          viewportFraction: 1.0,
                        ),
                      )
                    : InkWell(
                        onTap: () => pickImages(),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10.0),
                          dashPattern: const [10.0, 4.0],
                          child: Container(
                            height: 150.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open, size: 40.0),
                                const SizedBox(height: 15.0),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30.0),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 7,
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                ),
                const SizedBox(height: 10.0),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: currentCategory,
                    items: productCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        currentCategory = value!;
                      });
                    },
                  ),
                ),
                CustomButton(
                  text: 'Sell',
                  onPressed: () {
                    if (_addPostFormKey.currentState!.validate() &&
                        images.isNotEmpty) {
                      AdminServices().sellProduct(
                        context: context,
                        name: nameController.text,
                        description: descriptionController.text,
                        price: priceController.text,
                        quantity: quantityController.text,
                        category: currentCategory,
                        images: images,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
