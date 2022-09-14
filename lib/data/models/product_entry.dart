class ProductEntry {
  final int id;
  final String desc;
  final bool isAvailable;
  final double price;
  final List<String> types;

  ProductEntry({
    this.id = -1,
    this.desc = "",
    this.isAvailable = false,
    this.price = 0.0,
    this.types = const <String>[],
  });

  factory ProductEntry.fromMap(Map<String, dynamic> map) {
    return ProductEntry(
      id: map['id']?.toInt() ?? 0,
      desc: map['desc'] ?? '',
      isAvailable: map['isAvailable'] ?? false,
      price: map['price']?.toDouble() ?? 0.0,
      types: List<String>.from(map['types']),
    );
  }
}
