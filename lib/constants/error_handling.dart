import 'package:amazon_clone/constants/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void dioErrorHandling({
  required BuildContext context,
  required Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(
        context,
        message: response.data['message'],
      );
      break;
    case 500:
      showSnackBar(
        context,
        message: response.data['error'],
      );
      break;
    default:
      showSnackBar(
        context,
        message: 'Something went wrong : ${response.data}',
      );
  }
}
