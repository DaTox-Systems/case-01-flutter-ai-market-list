import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/shopping_list_notifier.dart';
import '../widgets/shopping_item_card.dart';
import '../../../archive/presentation/notifiers/archive_notifier.dart';
import '../../../../core/widgets/app_toast.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список покупок'),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            onPressed: () => _showArchiveDialog(context),
          ),
        ],
      ),
      body: Consumer<ShoppingListNotifier>(
        builder: (context, notifier, _) {
          if (notifier.message != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppToast.show(context, notifier.message!);
              notifier.clearMessage();
            });
          }

          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifier.items.isEmpty) {
            return const Center(
                child: Text('Список покупок пуст. Добавьте товары из поиска.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: notifier.items.length,
                  itemBuilder: (context, index) {
                    final item = notifier.items[index];
                    return ShoppingItemCard(
                      item: item,
                      onToggle: () => notifier.toggleItem(item),
                      onDelete: () => notifier.deleteItem(item.id!, item.name),
                      onUpdatePrice: (newPrice) =>
                          notifier.updateItemPrice(item, newPrice),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ИТОГО:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(
                      '${notifier.totalAmount.toStringAsFixed(2)} ₺',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xFF00BCD4)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showArchiveDialog(BuildContext context) {
    final controller = TextEditingController(
        text: 'Покупки от ${DateTime.now().day}.${DateTime.now().month}');
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Архивировать список?'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Название архива'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final success = await context
                  .read<ShoppingListNotifier>()
                  .archiveCurrentList(controller.text);
              if (success && context.mounted) {
                await context.read<ArchiveNotifier>().loadArchivedLists();
              }
            },
            child: const Text('Архивировать'),
          ),
        ],
      ),
    );
  }
}
