// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/product_model.dart';

class Order {
  final String id;
  final dynamic totalAmount;
  final List<OrderItem> items;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;

  Order(this.id, this.totalAmount, this.items, this.address, this.userId,
      this.orderedAt, this.status);

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      map['_id'] as String,
      map['totalAmount'] as dynamic,
      List<OrderItem>.from(
        (map['products'] as List<dynamic>).map<OrderItem>(
          (x) => OrderItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['address'] as String,
      map['userId'] as String,
      map['orderedAt'] as int,
      map['status'] as int,
    );
  }

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem(this.product, this.quantity);

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      Product.fromMap(map['product'] as Map<String, dynamic>),
      map['quantity'] as int,
    );
  }

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
