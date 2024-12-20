import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isNightMode = false;

  bool get isNightMode => _isNightMode;

  void toggleTheme() {
    _isNightMode = !_isNightMode;
    notifyListeners();
  }

  void setInitialTheme(DateTime date) {
    _isNightMode = date.hour >= 18 || date.hour < 6;
    notifyListeners();
  }
}
