import '../../../shopping_list/domain/entities/shopping_item_entity.dart';

class ArchivedListEntity {
  final int? id;
  final String name;
  final DateTime date;
  final double totalAmount;
  final List<ShoppingItemEntity> items;

  const ArchivedListEntity({
    this.id,
    required this.name,
    required this.date,
    required this.totalAmount,
    this.items = const [],
  });
}
