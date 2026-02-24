import 'package:flutter/widgets.dart';

class FontUtils {
  static String? getCourierFont(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar' || lang == 'zh') return null;
    return 'Courier';
  }

  static String? getSentinelBrandFont(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'ar' || lang == 'zh') return null;
    return 'SentinelBrand';
  }
}
