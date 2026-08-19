import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/network/api_client.dart';
import '../core/storage/database_helper.dart';
import '../features/products_search/data/datasources/product_remote_data_source.dart';
import '../features/products_search/data/repositories/product_repository_impl.dart';
import '../features/products_search/domain/repositories/i_product_repository.dart';
import '../features/products_search/presentation/notifiers/product_search_notifier.dart';
import '../features/shopping_list/data/datasources/shopping_local_data_source.dart';
import '../features/shopping_list/data/repositories/shopping_repository_impl.dart';
import '../features/shopping_list/domain/repositories/i_shopping_repository.dart';
import '../features/shopping_list/presentation/notifiers/shopping_list_notifier.dart';
import '../features/archive/data/datasources/archive_local_data_source.dart';
import '../features/archive/data/repositories/archive_repository_impl.dart';
import '../features/archive/domain/repositories/i_archive_repository.dart';
import '../features/archive/presentation/notifiers/archive_notifier.dart';

class InjectionContainer {
  InjectionContainer._();

  static List<SingleChildWidget> buildProviders() {
    // 1. Core Singletons
    final apiClient = ApiClient();
    final databaseHelper = DatabaseHelper();

    // 2. DataSources
    final productRemoteDataSource = ProductRemoteDataSourceImpl(client: apiClient);
    final shoppingLocalDataSource = ShoppingLocalDataSourceImpl(dbHelper: databaseHelper);
    final archiveLocalDataSource = ArchiveLocalDataSourceImpl(dbHelper: databaseHelper);

    // 3. Repositories
    final IProductRepository productRepository = ProductRepositoryImpl(remoteDataSource: productRemoteDataSource);
    final IShoppingRepository shoppingRepository = ShoppingRepositoryImpl(localDataSource: shoppingLocalDataSource);
    final IArchiveRepository archiveRepository = ArchiveRepositoryImpl(localDataSource: archiveLocalDataSource);

    // 4. Presentation Notifiers
    return [
      ChangeNotifierProvider<ProductSearchNotifier>(
        create: (_) => ProductSearchNotifier(repository: productRepository),
      ),
      ChangeNotifierProvider<ShoppingListNotifier>(
        create: (_) => ShoppingListNotifier(
          shoppingRepository: shoppingRepository,
          archiveRepository: archiveRepository,
        ),
      ),
      ChangeNotifierProvider<ArchiveNotifier>(
        create: (_) => ArchiveNotifier(repository: archiveRepository),
      ),
    ];
  }
}
