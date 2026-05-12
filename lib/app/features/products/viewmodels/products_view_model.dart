import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listinhax/app/core/result.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/domain/models/product.dart';

class ProductsViewModel extends ChangeNotifier {
  final ProductsRepository _productsRepository;

  bool _isLoading = true;
  List<Product> _products = [];
  String _feedback = '';
  String _error = '';

  StreamSubscription<List<Product>>? _streamSubscription;

  ProductsViewModel({required ProductsRepository productsRepository})
    : _productsRepository = productsRepository {
    _listenToProducts();
    // Keep cart count in sync when repository notifies (e.g. cart changes).
    _productsRepository.addListener(_onRepositoryChanged);
  }

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  bool get isLoading => _isLoading;
  List<Product> get products => List<Product>.unmodifiable(_products);
  String get feedback => _feedback;
  String get error => _error;
  int get cartItemsCount => _productsRepository.cartItems.length;

  bool isInCart(Product product) {
    return _productsRepository.cartItems
        .any((item) => item.product.name == product.name);
  }

  // ---------------------------------------------------------------------------
  // Stream subscription
  // ---------------------------------------------------------------------------

  void _listenToProducts() {
    _streamSubscription = _productsRepository.productsStream.listen(
      (products) {
        _products = products;
        _isLoading = false;
        _error = '';
        notifyListeners();
      },
      onError: (Object e) {
        _error = 'Erro ao carregar os produtos';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Commands
  // ---------------------------------------------------------------------------

  void saveProduct(String productName) {
    final trimmedName = productName.trim();
    if (trimmedName.isEmpty) return;

    final response = _productsRepository.addProduct(Product(name: trimmedName));
    if (response is Ok) {
      _feedback = '$trimmedName foi salvo!';
    } else if (response is Err) {
      _feedback = 'Erro ao salvar, tente novamente!';
    }
    notifyListeners();
  }

  void clearFeedback() {
    if (_feedback.isEmpty) return;
    _feedback = '';
    notifyListeners();
  }

  void toggleProductInCart(Product product) {
    _productsRepository.toggleCartItem(product);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _onRepositoryChanged() {
    // Triggered by cart mutations on the repository.
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _productsRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
