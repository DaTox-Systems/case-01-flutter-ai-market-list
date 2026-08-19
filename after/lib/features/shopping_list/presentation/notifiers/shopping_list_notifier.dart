import 'package:flutter/foundation.dart';
import '../../domain/entities/shopping_item_entity.dart';
import '../../domain/repositories/i_shopping_repository.dart';
import '../../../archive/domain/repositories/i_archive_repository.dart';
import '../../../../core/utils/ui_message.dart';

class ShoppingListNotifier extends ChangeNotifier {
  final IShoppingRepository _shoppingRepository;
  final IArchiveRepository _archiveRepository;

  ShoppingListNotifier({
    required IShoppingRepository shoppingRepository,
    required IArchiveRepository archiveRepository,
  })  : _shoppingRepository = shoppingRepository,
        _archiveRepository = archiveRepository {
    loadItems();
  }

  List<ShoppingItemEntity> _items = [];
  bool _isLoading = false;
  UiMessage? _message;

  List<ShoppingItemEntity> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  UiMessage? get message => _message;

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _shoppingRepository.getItems();
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка загрузки', description: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(ShoppingItemEntity item) async {
    try {
      await _shoppingRepository.insertItem(item);
      await loadItems();
      _message = UiMessage.success(
        title: 'Товар добавлен',
        description: '${item.name} успешно добавлен в список.',
      );
      notifyListeners();
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка добавления', description: e.toString());
      notifyListeners();
    }
  }

  Future<void> toggleItem(ShoppingItemEntity item) async {
    try {
      final updated = item.copyWith(isCompleted: !item.isCompleted);
      await _shoppingRepository.updateItem(updated);
      await loadItems();
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка обновления', description: e.toString());
      notifyListeners();
    }
  }

  Future<void> deleteItem(int id, String name) async {
    try {
      await _shoppingRepository.deleteItem(id);
      await loadItems();
      _message = UiMessage.info(
        title: 'Товар удален',
        description: '$name удален из списка.',
      );
      notifyListeners();
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка удаления', description: e.toString());
      notifyListeners();
    }
  }

  Future<void> updateItemPrice(ShoppingItemEntity item, double newPrice) async {
    try {
      final updated = item.copyWith(price: newPrice);
      await _shoppingRepository.updateItem(updated);
      await loadItems();
      _message = UiMessage.success(
        title: 'Цена обновлена',
        description: '${item.name}: ${newPrice.toStringAsFixed(2)} ₺',
      );
      notifyListeners();
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка обновления цены', description: e.toString());
      notifyListeners();
    }
  }

  Future<bool> archiveCurrentList(String listName) async {
    if (_items.isEmpty) {
      _message = const UiMessage.error(
        title: 'Ошибка архивации',
        description: 'Список покупок пуст.',
      );
      notifyListeners();
      return false;
    }

    try {
      await _archiveRepository.archiveList(
        name: listName.trim().isEmpty ? 'Список от ${DateTime.now().toLocal()}' : listName.trim(),
        totalAmount: totalAmount,
        items: _items,
      );

      await _shoppingRepository.clearList();
      _items = [];
      _message = UiMessage.success(
        title: 'Список архивирован',
        description: '$listName успешно сохранен в архив.',
      );
      notifyListeners();
      return true;
    } catch (e) {
      _message = UiMessage.error(title: 'Ошибка архивации', description: e.toString());
      notifyListeners();
      return false;
    }
  }

  void clearMessage() {
    _message = null;
  }
}
