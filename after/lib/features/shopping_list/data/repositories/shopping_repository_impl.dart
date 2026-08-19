import '../../domain/entities/shopping_item_entity.dart';
import '../../domain/repositories/i_shopping_repository.dart';
import '../datasources/shopping_local_data_source.dart';
import '../models/shopping_item_model.dart';

class ShoppingRepositoryImpl implements IShoppingRepository {
  final IShoppingLocalDataSource _localDataSource;

  ShoppingRepositoryImpl({required IShoppingLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<ShoppingItemEntity>> getItems() async {
    return _localDataSource.getItems();
  }

  @override
  Future<int> insertItem(ShoppingItemEntity item) {
    return _localDataSource.insertItem(ShoppingItemModel.fromEntity(item));
  }

  @override
  Future<int> updateItem(ShoppingItemEntity item) {
    return _localDataSource.updateItem(ShoppingItemModel.fromEntity(item));
  }

  @override
  Future<int> deleteItem(int id) {
    return _localDataSource.deleteItem(id);
  }

  @override
  Future<void> clearList() {
    return _localDataSource.clearList();
  }
}
