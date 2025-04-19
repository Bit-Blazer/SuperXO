import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppProvider with ChangeNotifier, WidgetsBindingObserver {
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  bool isSoundOn = true;

  AppProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }

  void toggleSound() {
    isSoundOn = !isSoundOn;
    notifyListeners();
  }
}
