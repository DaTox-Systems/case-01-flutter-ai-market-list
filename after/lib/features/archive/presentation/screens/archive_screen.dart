import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/archive_notifier.dart';
import '../widgets/archived_list_detail_dialog.dart';
import '../../../../core/widgets/app_toast.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Архив списков'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => context.read<ArchiveNotifier>().toggleSortOrder(),
          ),
        ],
      ),
      body: Consumer<ArchiveNotifier>(
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

          if (notifier.archivedLists.isEmpty) {
            return const Center(child: Text('Архив пока пуст'));
          }

          return ListView.builder(
            itemCount: notifier.archivedLists.length,
            itemBuilder: (context, index) {
              final list = notifier.archivedLists[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  title: Text(list.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${list.items.length} товаров • ${list.totalAmount.toStringAsFixed(2)} ₺'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined,
                            color: Color(0xFF00BCD4)),
                        onPressed: () =>
                            ArchivedListDetailDialog.show(context, list),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Color(0xFFDA3633)),
                        onPressed: () =>
                            notifier.deleteArchivedList(list.id!, list.name),
                      ),
                    ],
                  ),
                  onTap: () => ArchivedListDetailDialog.show(context, list),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
