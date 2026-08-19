import '../../domain/entities/archived_list_entity.dart';
import '../../domain/repositories/i_archive_repository.dart';
import '../datasources/archive_local_data_source.dart';
import '../../../shopping_list/domain/entities/shopping_item_entity.dart';
import '../../../shopping_list/data/models/shopping_item_model.dart';

class ArchiveRepositoryImpl implements IArchiveRepository {
  final IArchiveLocalDataSource _localDataSource;

  ArchiveRepositoryImpl({required IArchiveLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<List<ArchivedListEntity>> getArchivedLists() {
    return _localDataSource.getArchivedLists();
  }

  @override
  Future<int> archiveList({
    required String name,
    required double totalAmount,
    required List<ShoppingItemEntity> items,
  }) {
    return _localDataSource.archiveList(
      name: name,
      totalAmount: totalAmount,
      items: items.map((e) => ShoppingItemModel.fromEntity(e)).toList(),
    );
  }

  @override
  Future<void> deleteArchivedList(int id) {
    return _localDataSource.deleteArchivedList(id);
  }
}
