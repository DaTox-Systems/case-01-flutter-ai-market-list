import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements IProductRepository {
  final IProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl({required IProductRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<ProductEntity>> searchProducts({
    required String query,
    String? sortType,
    int page = 1,
  }) {
    return _remoteDataSource.searchProducts(
      query: query,
      sortType: sortType,
      page: page,
    );
  }

  @override
  Future<ProductEntity> getProductDetail(String url) {
    return _remoteDataSource.getProductDetail(url);
  }
}
