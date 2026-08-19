import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.brand,
    required super.quantity,
    required super.unit,
    required super.image,
    required super.merchantId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      brand: json['brand'] ?? '',
      quantity: json['quantity']?.toString() ?? '1',
      unit: json['unit'] ?? '',
      image: json['image'] ?? '',
      merchantId: json['merchant_id']?.toString() ?? '',
    );
  }
}
