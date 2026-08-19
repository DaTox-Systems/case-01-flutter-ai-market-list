import 'package:flutter_test/flutter_test.dart';
import 'package:case_01_market_list/features/shopping_list/domain/entities/shopping_item_entity.dart';
import 'package:case_01_market_list/features/shopping_list/domain/repositories/i_shopping_repository.dart';
import 'package:case_01_market_list/features/archive/domain/entities/archived_list_entity.dart';
import 'package:case_01_market_list/features/archive/domain/repositories/i_archive_repository.dart';
import 'package:case_01_market_list/features/shopping_list/presentation/notifiers/shopping_list_notifier.dart';

class MockShoppingRepository implements IShoppingRepository {
  final List<ShoppingItemEntity> _storage = [];

  @override
  Future<List<ShoppingItemEntity>> getItems() async => List.unmodifiable(_storage);

  @override
  Future<int> insertItem(ShoppingItemEntity item) async {
    _storage.add(item.copyWith(id: _storage.length + 1));
    return _storage.length;
  }

  @override
  Future<int> updateItem(ShoppingItemEntity item) async {
    final idx = _storage.indexWhere((e) => e.id == item.id);
    if (idx != -1) _storage[idx] = item;
    return 1;
  }

  @override
  Future<int> deleteItem(int id) async {
    _storage.removeWhere((e) => e.id == id);
    return 1;
  }

  @override
  Future<void> clearList() async => _storage.clear();
}

class MockArchiveRepository implements IArchiveRepository {
  final List<ArchivedListEntity> _archives = [];

  @override
  Future<List<ArchivedListEntity>> getArchivedLists() async => List.unmodifiable(_archives);

  @override
  Future<int> archiveList({
    required String name,
    required double totalAmount,
    required List<ShoppingItemEntity> items,
  }) async {
    _archives.add(ArchivedListEntity(
      id: _archives.length + 1,
      name: name,
      date: DateTime.now(),
      totalAmount: totalAmount,
      items: items,
    ));
    return _archives.length;
  }

  @override
  Future<void> deleteArchivedList(int id) async {
    _archives.removeWhere((e) => e.id == id);
  }
}

void main() {
  late MockShoppingRepository mockShoppingRepo;
  late MockArchiveRepository mockArchiveRepo;
  late ShoppingListNotifier notifier;

  setUp(() {
    mockShoppingRepo = MockShoppingRepository();
    mockArchiveRepo = MockArchiveRepository();
    notifier = ShoppingListNotifier(
      shoppingRepository: mockShoppingRepo,
      archiveRepository: mockArchiveRepo,
    );
  });

  group('ShoppingListNotifier (Isolated Unit Tests)', () {
    test('Initial state should be empty without exceptions', () async {
      expect(notifier.items, isEmpty);
      expect(notifier.totalAmount, 0.0);
      expect(notifier.isLoading, false);
    });

    test('addItem correctly calculates total and emits success message without BuildContext', () async {
      const item = ShoppingItemEntity(name: 'Молоко', price: 35.50, quantity: 2.0);

      await notifier.addItem(item);

      expect(notifier.items.length, 1);
      expect(notifier.items.first.name, 'Молоко');
      expect(notifier.totalAmount, 71.0);
      expect(notifier.message?.title, 'Товар добавлен');
    });

    test('archiveCurrentList successfully saves archive and clears shopping list', () async {
      const item1 = ShoppingItemEntity(name: 'Хлеб', price: 15.0, quantity: 1.0);
      const item2 = ShoppingItemEntity(name: 'Сыр', price: 100.0, quantity: 1.0);

      await notifier.addItem(item1);
      await notifier.addItem(item2);
      expect(notifier.totalAmount, 115.0);

      final success = await notifier.archiveCurrentList('Недельные покупки');

      expect(success, true);
      expect(notifier.items, isEmpty);
      expect(notifier.totalAmount, 0.0);
      expect(notifier.message?.title, 'Список архивирован');
    });
  });
}
