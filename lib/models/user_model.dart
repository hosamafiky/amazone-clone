// ignore_for_file: public_member_api_docs, sort_constructors_first

class User {
  late String uid;
  late String name;
  late String email;
  late String address;
  late String type;
  late String token;
  late List<dynamic>? cart;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': uid,
      'name': name,
      'email': email,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    uid = json['_id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    type = json['type'];
    token = json['token'];
    cart = json['cart'] != null
        ? List<Map<String, dynamic>>.from(
            json['cart']?.map(
              (x) => Map<String, dynamic>.from(x),
            ),
          )
        : null;
  }

  User copyWith({
    final String? uid,
    final String? name,
    final String? email,
    final String? address,
    final String? type,
    final String? token,
    final List<dynamic>? cart,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
