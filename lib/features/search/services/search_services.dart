import 'dart:developer';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SearchServices {
  late Dio dio;

  SearchServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<List<Product>> fetchSearchProducts({
    required BuildContext context,
    required String query,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> products = [];
    try {
      Response response = await dio.get(
        '/api/products/search',
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
        queryParameters: {
          'name': query,
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
      }
    }
    return products;
  }
}
