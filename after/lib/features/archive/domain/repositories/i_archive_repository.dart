import '../entities/archived_list_entity.dart';
import '../../../shopping_list/domain/entities/shopping_item_entity.dart';

abstract class IArchiveRepository {
  Future<List<ArchivedListEntity>> getArchivedLists();
  Future<int> archiveList({
    required String name,
    required double totalAmount,
    required List<ShoppingItemEntity> items,
  });
  Future<void> deleteArchivedList(int id);
}
