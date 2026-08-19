import 'package:flutter/material.dart';
import '../../domain/entities/shopping_item_entity.dart';
import '../../../../core/theme/app_theme_constants.dart';
import 'update_price_dialog.dart';

class ShoppingItemCard extends StatelessWidget {
  final ShoppingItemEntity item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(double) onUpdatePrice;

  const ShoppingItemCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onUpdatePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      elevation: item.isCompleted ? 0.5 : 2,
      color: item.isCompleted ? Colors.grey.shade100 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemeConstants.cardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: item.isCompleted,
              activeColor: const Color(0xFF00E676),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              onChanged: (_) => onToggle(),
            ),
            const SizedBox(width: 6),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      color: item.isCompleted ? Colors.grey.shade500 : Colors.black87,
                    ),
                  ),
                  if (item.description != null && item.description!.isNotEmpty)
                    Text(
                      item.description!,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),

            // Price Clickable for Edit
            InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => UpdatePriceDialog.show(context, item, onUpdatePrice),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${item.totalPrice.toStringAsFixed(2)} ₺',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF00BCD4)),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF00BCD4)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Delete Action
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFDA3633), size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
