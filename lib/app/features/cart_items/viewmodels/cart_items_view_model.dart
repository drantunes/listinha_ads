import 'package:flutter/material.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/domain/models/cart_item.dart';

class CartItemsViewModel extends ChangeNotifier {
  final ProductsRepository _productsRepository;
  int _totalItems = 0;
  int _checkedItems = 0;
  double _oldProgress = 0;
  double _currentProgress = 0;

  CartItemsViewModel({required ProductsRepository productsRepository})
    : _productsRepository = productsRepository {
    _productsRepository.addListener(_onRepositoryChanged);
  }

  List<CartItem> get cartItems => _productsRepository.cartItems.toList();
  int get remainingItems => (_totalItems - _checkedItems).clamp(0, _totalItems);
  double get oldProgress => _oldProgress;
  double get currentProgress => _currentProgress;

  void startSession() {
    _totalItems = _productsRepository.cartItems.length;
    _checkedItems = 0;
    _oldProgress = 0;
    _currentProgress = 0;
  }

  void completeItem(CartItem cartItem) {
    if (_totalItems == 0) {
      return;
    }

    _checkedItems = (_checkedItems + 1).clamp(0, _totalItems);
    _oldProgress = _currentProgress;
    _currentProgress = _checkedItems / _totalItems;
    _productsRepository.toggleCartItem(cartItem.product);
  }

  void increase(CartItem cartItem) {
    _productsRepository.increase(cartItem);
  }

  void decrease(CartItem cartItem) {
    _productsRepository.decrease(cartItem);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _productsRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
