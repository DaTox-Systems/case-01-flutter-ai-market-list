import '../entities/product_entity.dart';

abstract class IProductRepository {
  Future<List<ProductEntity>> searchProducts({
    required String query,
    String? sortType,
    int page = 1,
  });

  Future<ProductEntity> getProductDetail(String url);
}
