import 'dart:convert';
import 'dart:developer';

import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/provides/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  late Dio dio;

  AuthServices() {
    final options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      receiveTimeout: 20 * 1000,
      sendTimeout: 20 * 1000,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    dio = Dio(options);
  }
  // Sign up with name, email and password
  void signUp(
    context, {
    required String name,
    required String email,
    required String password,
  }) async {
    Response response = await dio.post(
      '/api/signup',
      data: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );
    dioErrorHandling(
      context: context,
      response: response,
      onSuccess: () {
        showSnackBar(context,
            message: 'Successfully signed up, login with your credentials');
      },
    );
  }

  void signIn(
    context, {
    required String email,
    required String password,
  }) async {
    try {
      Response response = await dio.post(
        '/api/signin',
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      dioErrorHandling(
        context: context,
        response: response,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.data);
          await prefs.setString('x-auth-token', response.data['token']);
          Navigator.of(context).pushNamedAndRemoveUntil(
            BottomBar.routeName,
            (route) => false,
          );
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

  void getUserData(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('x-auth-token');

    if (token == null) {
      await prefs.setString('x-auth-token', '');
    }
    dio
        .post(
      '/isTokenValid',
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'x-auth-token': token,
        },
      ),
    )
        .then((value) async {
      var userResponse = await dio.get(
        '/',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'x-auth-token': token,
          },
        ),
      );

      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(userResponse.data);
    }).catchError((error) {
      if (error is DioError) {
        log(error.toString());
        showSnackBar(context, message: error.response!.data['message']);
      } else {
        log(error.toString());
        showSnackBar(context, message: error.toString());
      }
    });
  }
}
