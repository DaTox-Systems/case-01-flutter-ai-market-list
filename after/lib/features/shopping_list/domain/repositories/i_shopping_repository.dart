import '../entities/shopping_item_entity.dart';

abstract class IShoppingRepository {
  Future<List<ShoppingItemEntity>> getItems();
  Future<int> insertItem(ShoppingItemEntity item);
  Future<int> updateItem(ShoppingItemEntity item);
  Future<int> deleteItem(int id);
  Future<void> clearList();
}
