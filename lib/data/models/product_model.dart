import 'dart:convert';

class ProductModel {
  final int id;

  final String desc;

  final bool isAvailable;

  final double price;

  final List<String> types;

  ProductModel({
    this.id = -1,
    this.desc = "",
    this.isAvailable = false,
    this.price = 0.0,
    this.types = const <String>[],
  });

  ProductModel copyWith({
    int? id,
    String? desc,
    bool? isAvailable,
    double? price,
    List<String>? types,
  }) {
    return ProductModel(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      isAvailable: isAvailable ?? this.isAvailable,
      price: price ?? this.price,
      types: types ?? this.types,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'desc': desc,
      'isAvailable': isAvailable,
      'price': price,
      'types': types,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toInt() ?? 0,
      desc: map['desc'] ?? '',
      isAvailable: map['isAvailable'] ?? false,
      price: map['price']?.toDouble() ?? 0.0,
      types: List<String>.from(map['types']),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return toJson();
  }
}
