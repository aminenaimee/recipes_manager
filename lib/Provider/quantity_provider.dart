import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientsAmounts = [];
  int get currentNumber => _currentNumber;

  void setBaseIngredientAmounts(List<double> amounts) {
    _baseIngredientsAmounts = amounts;
    notifyListeners();
  }

  List<String> get updateIngrediantAmounts {
    return _baseIngredientsAmounts
        .map<String>((amount) => (amount * currentNumber).toStringAsFixed(1))
        .toList();
  }

  void increaseQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  void decreseQuantity() {
    if (_currentNumber > 1) {
      _currentNumber--;
      notifyListeners();
    }
    
  }
}
