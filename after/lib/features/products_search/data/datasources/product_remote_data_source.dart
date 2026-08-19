import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class IProductRemoteDataSource {
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? sortType,
    int page = 1,
  });

  Future<ProductModel> getProductDetail(String url);
}

class ProductRemoteDataSourceImpl implements IProductRemoteDataSource {
  final ApiClient _client;

  ProductRemoteDataSourceImpl({required ApiClient client}) : _client = client;

  static const List<ProductModel> _demoCatalog = [
    ProductModel(
        id: '1',
        name: 'Sütaş Süt (Молоко 1л)',
        price: 34.50,
        brand: 'Sütaş',
        quantity: '1',
        unit: 'л',
        image:
            'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200&auto=format&fit=crop&q=60',
        merchantId: '1'),
    ProductModel(
        id: '2',
        name: 'Halk Ekmek (Хлеб белый)',
        price: 12.00,
        brand: 'Halk',
        quantity: '1',
        unit: 'шт',
        image:
            'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&auto=format&fit=crop&q=60',
        merchantId: '2'),
    ProductModel(
        id: '3',
        name: 'Pınar Kaşar (Сыр 500г)',
        price: 145.00,
        brand: 'Pınar',
        quantity: '500',
        unit: 'г',
        image:
            'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=200&auto=format&fit=crop&q=60',
        merchantId: '1'),
    ProductModel(
        id: '4',
        name: 'Amasya Elma (Яблоки 1кг)',
        price: 28.90,
        brand: 'Taze',
        quantity: '1',
        unit: 'кг',
        image:
            'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=200&auto=format&fit=crop&q=60',
        merchantId: '3'),
    ProductModel(
        id: '5',
        name: 'Çaykur Rize Çay (Чай 1кг)',
        price: 165.00,
        brand: 'Çaykur',
        quantity: '1',
        unit: 'кг',
        image:
            'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=200&auto=format&fit=crop&q=60',
        merchantId: '2'),
    ProductModel(
        id: '6',
        name: 'Köy Yumurtası (Яйца 10шт)',
        price: 48.00,
        brand: 'Köy',
        quantity: '10',
        unit: 'шт',
        image:
            'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=200&auto=format&fit=crop&q=60',
        merchantId: '1'),
    ProductModel(
        id: '7',
        name: 'Komili Zeytinyağı (Масло 1л)',
        price: 260.00,
        brand: 'Komili',
        quantity: '1',
        unit: 'л',
        image:
            'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=200&auto=format&fit=crop&q=60',
        merchantId: '3'),
  ];

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? sortType,
    int page = 1,
  }) async {
    try {
      final response = await _client.get(
        '/api.php',
        queryParameters: {
          'q': query,
          if (sortType != null) 'sort': sortType,
          'page': page,
        },
      );

      if (response is Map<String, dynamic> && response['success'] == true) {
        final list = response['products'] as List? ?? [];
        return list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      // Offline / Demo Fallback: поиск по каталогу при недоступности локального сервера
      final q = query.trim().toLowerCase();
      final results = _demoCatalog.where((item) {
        return item.name.toLowerCase().contains(q) ||
            item.brand.toLowerCase().contains(q);
      }).toList();

      if (sortType == 'price-asc') {
        results.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortType == 'price-desc') {
        results.sort((a, b) => b.price.compareTo(a.price));
      }
      return results;
    }
  }

  @override
  Future<ProductModel> getProductDetail(String url) async {
    try {
      final response = await _client.get(url);
      if (response is Map<String, dynamic> && response['success'] == true) {
        return ProductModel.fromJson(
            response['product'] as Map<String, dynamic>);
      }
    } catch (_) {}
    return _demoCatalog.first;
  }
}
