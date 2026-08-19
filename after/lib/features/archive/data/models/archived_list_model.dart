import '../../domain/entities/archived_list_entity.dart';
import '../../../shopping_list/domain/entities/shopping_item_entity.dart';

class ArchivedListModel extends ArchivedListEntity {
  const ArchivedListModel({
    super.id,
    required super.name,
    required super.date,
    required super.totalAmount,
    super.items = const [],
  });

  factory ArchivedListModel.fromDb(
    Map<String, dynamic> map,
    List<ShoppingItemEntity> items,
  ) {
    return ArchivedListModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
      items: items,
    );
  }
}
