import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartServices {
  late Dio dio;
  CartServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  void deleteFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      Response response = await dio.delete(
        '/api/remove-from-cart',
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
}
