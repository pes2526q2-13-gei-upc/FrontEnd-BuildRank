import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _languageCodeKey = 'selected_language_code';
  static const defaultLocale = Locale('ca');
  static const supportedLocales = [Locale('ca'), Locale('es'), Locale('en')];

  Locale _locale = defaultLocale;

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    _locale = _localeForCode(languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    final nextLocale = _localeForCode(locale.languageCode);
    if (_locale == nextLocale) return;

    _locale = nextLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, nextLocale.languageCode);
  }

  static Locale _localeForCode(String? languageCode) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => defaultLocale,
    );
  }
}

class LocaleControllerScope extends InheritedNotifier<LocaleController> {
  const LocaleControllerScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LocaleControllerScope>();
    assert(scope != null, 'No LocaleControllerScope found in context.');
    return scope!.notifier!;
  }
}
