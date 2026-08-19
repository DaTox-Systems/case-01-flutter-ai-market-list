import 'package:flutter/material.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/theme/app_theme_constants.dart';

class ProductDetailDialog extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onAddToList;

  const ProductDetailDialog({
    super.key,
    required this.product,
    required this.onAddToList,
  });

  static void show(BuildContext context, ProductEntity product, VoidCallback onAddToList) {
    showDialog(
      context: context,
      builder: (ctx) => ProductDetailDialog(
        product: product,
        onAddToList: () {
          Navigator.pop(ctx);
          onAddToList();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final merchantColor = AppThemeConstants.getMerchantColor(product.merchantId);
    final merchantName = AppThemeConstants.getMerchantName(product.merchantId);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemeConstants.cardRadius)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: merchantColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppThemeConstants.badgeRadius),
                  ),
                  child: Text(
                    merchantName,
                    style: TextStyle(color: merchantColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Бренд: ${product.brand} • Фасовка: ${product.quantity} ${product.unit}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Цена в магазине:', style: TextStyle(fontWeight: FontWeight.w500)),
                  Text(
                    '${product.price.toStringAsFixed(2)} ₺',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00BCD4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Добавить в список покупок', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: onAddToList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
