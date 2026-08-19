import '../../domain/entities/shopping_item_entity.dart';

class ShoppingItemModel extends ShoppingItemEntity {
  const ShoppingItemModel({
    super.id,
    required super.name,
    required super.price,
    super.quantity = 1.0,
    super.unit,
    super.description,
    super.imageUrl,
    super.marketImageUrl,
    super.isCompleted = false,
  });

  factory ShoppingItemModel.fromEntity(ShoppingItemEntity entity) {
    return ShoppingItemModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      quantity: entity.quantity,
      unit: entity.unit,
      description: entity.description,
      imageUrl: entity.imageUrl,
      marketImageUrl: entity.marketImageUrl,
      isCompleted: entity.isCompleted,
    );
  }

  factory ShoppingItemModel.fromMap(Map<String, dynamic> map) {
    return ShoppingItemModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: map['unit'] as String?,
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      marketImageUrl: map['market_image_url'] as String?,
      isCompleted: (map['is_completed'] == 1),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'description': description,
      'image_url': imageUrl,
      'market_image_url': marketImageUrl,
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}
