import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/product_search_notifier.dart';
import '../widgets/product_card.dart';
import '../../../shopping_list/presentation/notifiers/shopping_list_notifier.dart';
import '../../../../core/widgets/app_toast.dart';

class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск товаров'),
      ),
      body: Consumer<ProductSearchNotifier>(
        builder: (context, notifier, _) {
          if (notifier.message != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppToast.show(context, notifier.message!);
              notifier.clearMessage();
            });
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск по маркетам...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: notifier.onSearchQueryChanged,
                ),
              ),
              if (notifier.isLoading) const LinearProgressIndicator(),
              Expanded(
                child: notifier.products.isEmpty
                    ? Center(
                        child: Text(
                          'Введите запрос для поиска товаров (например, "sut" или "молоко")',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        itemCount: notifier.products.length,
                        itemBuilder: (context, index) {
                          final product = notifier.products[index];
                          return ProductCard(
                            product: product,
                            onAdd: () {
                              context
                                  .read<ShoppingListNotifier>()
                                  .addItem(product.toShoppingItem());
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
