import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/order_model.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/sales.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminServices {
  late Dio dio;
  AdminServices() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
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

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required String price,
    required String quantity,
    required String category,
    required List<File> images,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final cloudinary = CloudinaryPublic('dmjcceeio', 'bzxvefyi');
      List<String> imageUrls = [];
      for (var image in images) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: name.trim()),
        );
        imageUrls.add(response.secureUrl);
      }
      Product product = Product(
        name: name,
        description: description,
        price: double.parse(price),
        quantity: int.parse(quantity),
        images: imageUrls,
        category: category,
      );

      Response response = await dio.post(
        '/admin/addProduct',
        data: product.toJson(),
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
      );

      dioErrorHandling(
          context: context,
          response: response,
          onSuccess: () {
            showSnackBar(context, message: 'Product added successfully');
            Navigator.pop(context);
          });
    } catch (e) {
      log(e.toString());
      showSnackBar(context, message: e.toString());
    }
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      Response response = await dio.post(
        '/admin/deleteProduct',
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
          showSnackBar(context, message: 'Product deleted successfully');
        },
      );
    } catch (e) {
      log(e.toString());
      showSnackBar(context, message: e.toString());
    }
  }

  // Get Products
  Future<List<Product>> getAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> products = [];
    try {
      Response response = await dio.get(
        '/admin/getProducts',
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
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

  // Get Analytics
  Future<Map<String, dynamic>> getAnalytics(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sale> sales = [];
    dynamic totalEarnings = 0;
    try {
      Response response = await dio.get(
        '/admin/analytics',
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
      );
      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          var data = response.data;
          totalEarnings = data['totalEarning'];
          sales = [
            Sale('Mobiles', data['mobilesEarnings']),
            Sale('Essentials', data['essentialEarnings']),
            Sale('Appliances', data['appliancesEarnings']),
            Sale('Books', data['booksEarnings']),
            Sale('Fashion', data['fashionEarnings']),
          ];
        },
      );
    } catch (error) {
      if (error is DioError) {
        log(error.response!.data['error']);
        showSnackBar(context, message: error.response!.data['error']);
      } else {
        log(error.toString());
        showSnackBar(context, message: error.toString());
      }
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarnings,
    };
  }

  // Get Orders
  Future<List<Order>> getAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orders = [];
    try {
      Response response = await dio.get(
        '/admin/getOrders',
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
      );
      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          response.data.forEach((order) {
            orders.add(Order.fromMap(order));
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
    return orders;
  }

  // Update order status
  void updateOrderStatus({
    required BuildContext context,
    required Order order,
    required int status,
    required Function() onSuccess,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      Response response = await dio.post(
        '/admin/updateOrder',
        data: jsonEncode({
          'id': order.id,
          'status': status,
        }),
        options: Options(
          contentType: 'application/json',
          headers: {'x-auth-token': userProvider.user.token},
        ),
      );

      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: onSuccess,
      );
    } catch (e) {
      log(e.toString());
      showSnackBar(context, message: e.toString());
    }
  }
}
