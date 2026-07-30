import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    notifyListeners();
  }

  bool get isUrdu => _currentLanguage == 'ur';
  
  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'en' ? 'ur' : 'en';
    notifyListeners();
  }
}
