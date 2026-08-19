class ShoppingItemEntity {
  final int? id;
  final String name;
  final double price;
  final double quantity;
  final String? unit;
  final String? description;
  final String? imageUrl;
  final String? marketImageUrl;
  final bool isCompleted;

  const ShoppingItemEntity({
    this.id,
    required this.name,
    required this.price,
    this.quantity = 1.0,
    this.unit,
    this.description,
    this.imageUrl,
    this.marketImageUrl,
    this.isCompleted = false,
  });

  double get totalPrice => price * quantity;

  ShoppingItemEntity copyWith({
    int? id,
    String? name,
    double? price,
    double? quantity,
    String? unit,
    String? description,
    String? imageUrl,
    String? marketImageUrl,
    bool? isCompleted,
  }) {
    return ShoppingItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      marketImageUrl: marketImageUrl ?? this.marketImageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
