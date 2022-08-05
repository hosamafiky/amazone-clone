import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AddressServices {
  late Dio dio;

  AddressServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  void updateUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      Response response = await dio.post(
        '/api/update-address',
        data: jsonEncode({
          'address': address,
        }),
        options: Options(contentType: 'application/json', headers: {
          'x-auth-token': user.token,
        }),
      );

      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          User user = userProvider.user.copyWith(
            address: response.data['address'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (error) {
      if (error is DioError) {
        showSnackBar(context, message: error.response!.data['message']);
      } else {
        showSnackBar(context, message: error.toString());
      }
    }
  }

  // Place an Order
  void placeAnOrder({
    required BuildContext context,
    required String address,
    required double totalAmount,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Response response = await dio.post(
        '/api/order',
        data: jsonEncode({
          'cart': userProvider.user.cart,
          'totalAmount': totalAmount,
          'address': address,
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
          showSnackBar(context, message: 'Your order has been placed!');
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          User user = userProvider.user.copyWith(
            cart: [],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (error) {
      if (error is DioError) {
        showSnackBar(context, message: error.response!.data['message']);
      } else {
        showSnackBar(context, message: error.toString());
      }
    }
  }
}
