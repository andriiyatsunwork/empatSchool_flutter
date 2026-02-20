import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  int _likesCount = 0;

  bool get isDarkMode => _isDarkMode;
  int get likesCount => _likesCount;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Кричимо: тема змінилась!
  }

  void addLike() {
    _likesCount++;
    notifyListeners(); // Кричимо: додався лайк!
  }
}