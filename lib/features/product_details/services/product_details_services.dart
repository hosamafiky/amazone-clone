import 'dart:convert';
import 'dart:developer';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProductDetailsServices {
  late Dio dio;
  ProductDetailsServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      Response response = await dio.post(
        '/api/add-to-cart',
        data: jsonEncode({
          'id': product.id,
        }),
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
      );

      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            cart: response.data['cart'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      if (e is DioError) {
        showSnackBar(context, message: e.response!.data['message']);
      } else {
        showSnackBar(context, message: e.toString());
      }
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      Response response = await dio.post(
        '/api/rateProduct',
        data: jsonEncode({
          'id': product.id,
          'rating': rating,
        }),
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
      );

      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          showSnackBar(context, message: 'Thanks for your rating ♥');
        },
      );
    } catch (e) {
      if (e is DioError) {
        log(e.response!.data['message']);
        showSnackBar(context, message: e.response!.data['message']);
      } else {
        log(e.toString());
        showSnackBar(context, message: e.toString());
      }
    }
  }
}
