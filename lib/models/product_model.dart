// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/rating_model.dart';

class Product {
  final String name;
  final String description;
  final double price;
  final int quantity;
  final List<String> images;
  final String category;
  final String? id;
  final List<RatingModel>? rating;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.images,
    required this.category,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'images': images,
      'category': category,
      '_id': id,
      'rating': rating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      description: map['description'] as String,
      price: double.parse(map['price'].toString()),
      quantity: map['quantity'] as int,
      images: List<String>.from((map['images'] as List<dynamic>)),
      category: map['category'] as String,
      id: map['_id'] != null ? map['_id'] as String : null,
      rating: map['rating'] != null
          ? List<RatingModel>.from(
              map['rating']?.map(
                (x) => RatingModel.fromJson(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());
}
