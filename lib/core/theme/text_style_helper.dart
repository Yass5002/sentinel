import 'package:flutter/widgets.dart';

class TextStyleHelper {
  static double getLetterSpacing(BuildContext context, double defaultSpacing) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? 0.0 : defaultSpacing;
  }
}
