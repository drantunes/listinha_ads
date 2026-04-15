import 'package:flutter/material.dart';
import 'package:listinhax/app/core/result.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/domain/models/product.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsRepository _productsRepository;
  bool _isLoading = false;
  List<Product> _products = <Product>[];
  String _feedback = '';

  ProductsViewModel({required ProductsRepository productsRepository})
      : _productsRepository = productsRepository {
    _productsRepository.addListener(_syncFromRepository);
    _syncFromRepository();
  }

  bool get isLoading => _isLoading;
  List<Product> get products => List<Product>.unmodifiable(_products);
  String get feedback => _feedback;
  int get cartItemsCount => _productsRepository.cartItems.length;

  bool isInCart(Product product) {
    return _productsRepository.cartItems.any((item) => item.product.name == product.name);
  }

  Future<void> load() async {
    _isLoading = true;
    _feedback = '';
    notifyListeners();

    final result = await _productsRepository.loadProducts();
    switch (result) {
      case Ok():
        _products = result.value;
      case Err():
        _feedback = result.value;
    }

    _isLoading = false;
    notifyListeners();
  }

  void saveProduct(String productName) {
    final trimmedName = productName.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    _productsRepository.addProduct(Product(name: trimmedName));
    _feedback = '$trimmedName foi salvo!';
    notifyListeners();
  }

  void clearFeedback() {
    if (_feedback.isEmpty) {
      return;
    }

    _feedback = '';
    notifyListeners();
  }

  void toggleProductInCart(Product product) {
    _productsRepository.toggleCartItem(product);
  }

  void _syncFromRepository() {
    _products = _productsRepository.products.toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _productsRepository.removeListener(_syncFromRepository);
    super.dispose();
  }
}
