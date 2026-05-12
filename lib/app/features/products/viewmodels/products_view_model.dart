import 'package:flutter/material.dart';
import 'package:listinhax/app/core/result.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/domain/models/product.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsRepository _repository;

  bool _isLoading = false;
  List<Product> _products = [];
  String _feedback = '';
  String _error = '';

  ProductsViewModel({required ProductsRepository productsRepository})
    : _repository = productsRepository {
    load();
  }

  bool get isLoading => _isLoading;
  List<Product> get products => List<Product>.unmodifiable(_products);
  String get feedback => _feedback;
  String get error => _error;
  int get cartItemsCount => _repository.cartItems.length;

  bool isInCart(Product product) =>
      _repository.cartItems.any((item) => item.product.name == product.name);

  Future<void> load() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    final result = await _repository.loadProducts();

    switch (result) {
      case Ok(:final value):
        _products = value;
      case Err(:final value):
        _error = value;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveProduct(String productName) async {
    final name = productName.trim();
    if (name.isEmpty) return;

    final result = await _repository.addProduct(Product(name: name));

    switch (result) {
      case Ok():
        _feedback = '$name foi salvo!';
        await load();
      case Err(:final value):
        _feedback = value;
        notifyListeners();
    }
  }

  void clearFeedback() {
    if (_feedback.isEmpty) return;
    _feedback = '';
    notifyListeners();
  }

  void toggleProductInCart(Product product) {
    _repository.toggleCartItem(product);
    notifyListeners();
  }
}
