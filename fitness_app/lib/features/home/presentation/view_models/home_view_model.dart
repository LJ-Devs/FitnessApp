import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Function call when click
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}