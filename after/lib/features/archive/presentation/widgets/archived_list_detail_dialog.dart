import 'package:flutter/material.dart';
import '../../domain/entities/archived_list_entity.dart';
import '../../../../core/theme/app_theme_constants.dart';

class ArchivedListDetailDialog extends StatelessWidget {
  final ArchivedListEntity list;

  const ArchivedListDetailDialog({super.key, required this.list});

  static void show(BuildContext context, ArchivedListEntity list) {
    showDialog(
      context: context,
      builder: (ctx) => ArchivedListDetailDialog(list: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemeConstants.cardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(list.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            Text(
              'Дата: ${list.date.day}.${list.date.month}.${list.date.year} • Итого: ${list.totalAmount.toStringAsFixed(2)} ₺',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const Divider(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: list.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = list.items[index];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${item.quantity} ${item.unit ?? "шт"}'),
                    trailing: Text('${item.price.toStringAsFixed(2)} ₺', style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
