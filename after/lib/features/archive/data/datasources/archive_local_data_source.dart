import '../../../../core/storage/database_helper.dart';
import '../models/archived_list_model.dart';
import '../../../shopping_list/data/models/shopping_item_model.dart';

abstract class IArchiveLocalDataSource {
  Future<List<ArchivedListModel>> getArchivedLists();
  Future<int> archiveList({
    required String name,
    required double totalAmount,
    required List<ShoppingItemModel> items,
  });
  Future<void> deleteArchivedList(int id);
}

class ArchiveLocalDataSourceImpl implements IArchiveLocalDataSource {
  final DatabaseHelper _dbHelper;

  ArchiveLocalDataSourceImpl({required DatabaseHelper dbHelper})
      : _dbHelper = dbHelper;

  @override
  Future<List<ArchivedListModel>> getArchivedLists() async {
    final db = await _dbHelper.database;
    final listMaps = await db.query('archived_lists', orderBy: 'date DESC');

    List<ArchivedListModel> result = [];
    for (var lMap in listMaps) {
      final listId = lMap['id'] as int;
      final itemMaps = await db.query(
        'archived_items',
        where: 'list_id = ?',
        whereArgs: [listId],
      );

      final items = itemMaps.map((e) => ShoppingItemModel.fromMap(e)).toList();
      result.add(ArchivedListModel.fromDb(lMap, items));
    }
    return result;
  }

  @override
  Future<int> archiveList({
    required String name,
    required double totalAmount,
    required List<ShoppingItemModel> items,
  }) async {
    final db = await _dbHelper.database;
    int listId = 0;

    await db.transaction((txn) async {
      listId = await txn.insert('archived_lists', {
        'name': name,
        'date': DateTime.now().toIso8601String(),
        'total_amount': totalAmount,
      });

      for (var item in items) {
        await txn.insert('archived_items', {
          'list_id': listId,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'unit': item.unit,
          'description': item.description,
          'is_completed': item.isCompleted ? 1 : 0,
        });
      }

      await txn.delete('shopping_items');
    });

    return listId;
  }

  @override
  Future<void> deleteArchivedList(int id) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.delete('archived_items', where: 'list_id = ?', whereArgs: [id]);
      await txn.delete('archived_lists', where: 'id = ?', whereArgs: [id]);
    });
  }
}
