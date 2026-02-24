import 'package:flutter/material.dart';

class L10nHelper {
  /// Returns whether the current locale is Right-to-Left.
  static bool isRtl(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Returns whether the current locale should skip custom fonts (ar, zh).
  static bool shouldSkipCustomFont(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'ar' || locale == 'zh';
  }

  /// Wraps an icon to correctly flip it in RTL mode if it's not auto-mirrored.
  static Widget flippedIcon(
    BuildContext context,
    IconData icon, {
    double? size,
    Color? color,
  }) {
    if (isRtl(context)) {
      return Transform.scale(
        scaleX: -1,
        child: Icon(icon, size: size, color: color),
      );
    }
    return Icon(icon, size: size, color: color);
  }

  /// Returns a font family string or null if custom fonts should be skipped for ar/zh.
  static String? getFont(BuildContext context, String? preferredFont) {
    if (shouldSkipCustomFont(context)) return null;
    return preferredFont;
  }
}
