import 'dart:async';
import 'package:SMP/contants/language/english.dart';
import 'package:SMP/contants/language/hindi.dart';
import 'package:SMP/contants/language/spanish.dart';
import 'package:SMP/contants/language/tamil.dart';
import 'package:flutter/material.dart';

class AppTranslations {
  static Map<String, Map<String, String>> translations = {
    'en': EnglishTranslations.translations,
    'es': SpanishTranslations.translations,
    'ta': TamilTranslations.translations,
    'hi': HindiTranslations.translations,
  };

  static Future<String> load(Locale locale) async {
    return Future.value(true as FutureOr<String>?);
  }

  static String translate(String key, {String? languageCode}) {
    final effectiveLanguageCode = languageCode ?? 'en';
    return translations[effectiveLanguageCode]![key] ?? key;
  }
} 

class LocalizationUtil {
  static Locale currentLocale = const Locale('en', 'US');

  static String translate(String key) {
    return AppTranslations.translate(key,
        languageCode: currentLocale.languageCode);
  }
}
