import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/theme/app_theme_constants.dart';
import 'product_detail_dialog.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final merchantColor =
        AppThemeConstants.getMerchantColor(product.merchantId);
    final merchantName = AppThemeConstants.getMerchantName(product.merchantId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.cardRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppThemeConstants.cardRadius),
        onTap: () => ProductDetailDialog.show(context, product, onAdd),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Product Image with CachedNetworkImage
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 65,
                  height: 65,
                  color: Colors.grey.shade100,
                  child: product.image.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                              child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2))),
                          errorWidget: (_, __, ___) => Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.grey.shade400,
                              size: 30),
                        )
                      : Icon(Icons.shopping_bag_outlined,
                          color: Colors.grey.shade400, size: 30),
                ),
              ),
              const SizedBox(width: 14),

              // 2. Info details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: merchantColor,
                            borderRadius: BorderRadius.circular(
                                AppThemeConstants.badgeRadius),
                          ),
                          child: Text(
                            merchantName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            borderRadius: BorderRadius.circular(
                                AppThemeConstants.badgeRadius),
                          ),
                          child: Text(
                            '${product.quantity} ${product.unit}',
                            style: TextStyle(
                                color: Colors.blueGrey.shade800,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Product title
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.brand,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const SizedBox(height: 8),

                    // Price & Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(2)} ₺',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00BCD4),
                          ),
                        ),
                        Material(
                          color:
                              const Color(0xFF00BCD4).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: onAdd,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add,
                                      size: 16, color: Color(0xFF00BCD4)),
                                  SizedBox(width: 2),
                                  Icon(Icons.shopping_cart_outlined,
                                      size: 16, color: Color(0xFF00BCD4)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
