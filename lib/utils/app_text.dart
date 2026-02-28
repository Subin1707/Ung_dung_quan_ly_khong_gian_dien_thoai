import 'package:flutter/material.dart';

class AppText {
  static String t(BuildContext context, String vi, String en) {
    return Localizations.localeOf(context).languageCode == 'vi' ? vi : en;
  }
}
