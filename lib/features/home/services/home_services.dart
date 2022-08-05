import 'dart:developer';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeServices {
  late Dio dio;

  HomeServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<List<Product>> fetchCategoryProducts(
      {required BuildContext context, required String category}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> products = [];
    try {
      Response response = await dio.get(
        '/api/products',
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
        queryParameters: {
          'category': category,
        },
      );
      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          response.data.forEach((product) {
            products.add(Product.fromMap(product));
          });
        },
      );
    } catch (error) {
      if (error is DioError) {
        log(error.response!.data['message']);
        showSnackBar(context, message: error.response!.data['message']);
      } else {
        log(error.toString());
        showSnackBar(context, message: error.toString());
      }
    }
    return products;
  }

  // Get deal of the day
  Future<Product> fetchDealOfDayProduct({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      price: 0.0,
      quantity: 0,
      images: [],
      category: '',
    );
    try {
      Response response = await dio.get(
        '/api/dealofday',
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
      );
      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          product = Product.fromMap(response.data);
        },
      );
    } catch (error) {
      if (error is DioError) {
        log(error.response!.data['message']);
        showSnackBar(context, message: error.response!.data['message']);
      } else {
        log(error.toString());
        showSnackBar(context, message: error.toString());
      }
    }
    return product;
  }
}
