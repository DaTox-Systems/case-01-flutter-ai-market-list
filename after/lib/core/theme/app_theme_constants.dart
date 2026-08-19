import 'package:flutter/material.dart';

class AppThemeConstants {
  AppThemeConstants._();

  static const Color primaryColor = Color(0xFF00BCD4);
  static const Color secondaryColor = Color(0xFF00E676);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;

  // Цвета бейджей турецких маркетов
  static const Color getirColor = Color(0xFF5D3EBC);
  static const Color a101Color = Color(0xFF00A2DE);
  static const Color sokColor = Color(0xFFED1C24);
  static const Color bimColor = Color(0xFF004F9F);
  static const Color migrosColor = Color(0xFFFF6000);

  static const double cardRadius = 16.0;
  static const double badgeRadius = 6.0;

  static Color getMerchantColor(String merchantId) {
    return switch (merchantId) {
      '1' => getirColor,
      '2' => a101Color,
      '3' => sokColor,
      '4' => bimColor,
      _ => migrosColor,
    };
  }

  static String getMerchantName(String merchantId) {
    return switch (merchantId) {
      '1' => 'Getir',
      '2' => 'A101',
      '3' => 'ŞOK',
      '4' => 'BİM',
      _ => 'Migros',
    };
  }
}
