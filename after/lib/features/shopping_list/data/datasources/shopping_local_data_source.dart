import '../../../../core/storage/database_helper.dart';
import '../models/shopping_item_model.dart';

abstract class IShoppingLocalDataSource {
  Future<List<ShoppingItemModel>> getItems();
  Future<int> insertItem(ShoppingItemModel item);
  Future<int> updateItem(ShoppingItemModel item);
  Future<int> deleteItem(int id);
  Future<void> clearList();
}

class ShoppingLocalDataSourceImpl implements IShoppingLocalDataSource {
  final DatabaseHelper _dbHelper;

  ShoppingLocalDataSourceImpl({required DatabaseHelper dbHelper})
      : _dbHelper = dbHelper;

  @override
  Future<List<ShoppingItemModel>> getItems() async {
    final db = await _dbHelper.database;
    final maps = await db.query('shopping_items');
    return maps.map((e) => ShoppingItemModel.fromMap(e)).toList();
  }

  @override
  Future<int> insertItem(ShoppingItemModel item) async {
    final db = await _dbHelper.database;
    return db.insert('shopping_items', item.toMap());
  }

  @override
  Future<int> updateItem(ShoppingItemModel item) async {
    final db = await _dbHelper.database;
    return db.update(
      'shopping_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<int> deleteItem(int id) async {
    final db = await _dbHelper.database;
    return db.delete('shopping_items', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> clearList() async {
    final db = await _dbHelper.database;
    await db.delete('shopping_items');
  }
}
