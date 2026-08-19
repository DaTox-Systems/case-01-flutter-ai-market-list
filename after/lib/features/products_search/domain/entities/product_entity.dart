import '../../../shopping_list/domain/entities/shopping_item_entity.dart';

class ProductEntity {
  final String id;
  final String name;
  final double price;
  final String brand;
  final String quantity;
  final String unit;
  final String image;
  final String merchantId;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.brand,
    required this.quantity,
    required this.unit,
    required this.image,
    required this.merchantId,
  });

  ShoppingItemEntity toShoppingItem() {
    return ShoppingItemEntity(
      name: name,
      price: price,
      quantity: 1.0,
      unit: unit,
      description: '$brand - $quantity $unit',
      imageUrl: image,
      marketImageUrl: '/logo.php?id=$merchantId',
      isCompleted: false,
    );
  }
}
