import 'package:flutter/material.dart';
import '../../domain/entities/shopping_item_entity.dart';
import '../../../../core/theme/app_theme_constants.dart';

class UpdatePriceDialog extends StatefulWidget {
  final ShoppingItemEntity item;
  final Function(double newPrice) onConfirm;

  const UpdatePriceDialog({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  static void show(BuildContext context, ShoppingItemEntity item, Function(double) onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => UpdatePriceDialog(item: item, onConfirm: onConfirm),
    );
  }

  @override
  State<UpdatePriceDialog> createState() => _UpdatePriceDialogState();
}

class _UpdatePriceDialogState extends State<UpdatePriceDialog> {
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.item.price.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemeConstants.cardRadius)),
      title: Text('Изменить цену: ${widget.item.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      content: TextField(
        controller: _priceController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Новая цена (₺)',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixText: '₺',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BCD4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            final parsed = double.tryParse(_priceController.text.replaceAll(',', '.'));
            if (parsed != null && parsed >= 0) {
              Navigator.pop(context);
              widget.onConfirm(parsed);
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
