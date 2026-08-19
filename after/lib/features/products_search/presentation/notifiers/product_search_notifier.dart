import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../../../../core/utils/ui_message.dart';

class ProductSearchNotifier extends ChangeNotifier {
  final IProductRepository _repository;

  ProductSearchNotifier({required IProductRepository repository})
      : _repository = repository;

  final List<ProductEntity> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _sortType;
  int _currentPage = 1;
  Timer? _debounceTimer;
  UiMessage? _message;

  List<ProductEntity> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get sortType => _sortType;
  UiMessage? get message => _message;

  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _currentPage = 1;
        _products.clear();
        searchProducts();
      }
    });
  }

  void setSortType(String? type) {
    _sortType = type;
    if (_searchQuery.trim().isNotEmpty) {
      _currentPage = 1;
      _products.clear();
      searchProducts();
    }
  }

  Future<void> searchProducts() async {
    if (_searchQuery.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final results = await _repository.searchProducts(
        query: _searchQuery.trim(),
        sortType: _sortType,
        page: _currentPage,
      );

      if (_currentPage == 1) {
        _products.clear();
      }
      _products.addAll(results);
    } catch (e) {
      _message = UiMessage.error(
        title: 'Ошибка поиска',
        description: e.toString(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    _message = null;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
