import 'package:flutter/material.dart';
import '../utils/ui_message.dart';

class AppToast {
  AppToast._();

  static void show(BuildContext context, UiMessage message) {
    final color = switch (message.type) {
      MessageType.success => const Color(0xFF00E676),
      MessageType.error => const Color(0xFFDA3633),
      MessageType.info => const Color(0xFF00BCD4),
    };

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (message.description.isNotEmpty)
              Text(
                message.description,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
