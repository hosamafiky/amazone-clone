import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/order_model.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  late Dio dio;

  AccountServices() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
    ));
  }

  Future<List<Order>> getOrders({required BuildContext context}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Order> orders = [];
    try {
      Response response = await dio.get(
        '/api/my-orders',
        options: Options(
          contentType: 'application/json',
          headers: {
            'x-auth-token': user.token,
          },
        ),
      );

      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          for (int i = 0; i < response.data.length; i++) {
            orders.add(Order.fromMap(response.data[i]));
          }
        },
      );
    } catch (error) {
      if (error is DioError) {
        showSnackBar(context, message: error.response!.data['message']);
      } else {
        showSnackBar(context, message: error.toString());
      }
    }
    return orders;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('x-auth-token', '').then((value) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AuthScreen.routeName,
          (route) => false,
        );
      });
    } catch (error) {
      showSnackBar(context, message: error.toString());
    }
  }
}
