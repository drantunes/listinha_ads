import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:listinhax/app/core/result.dart';
import 'package:listinhax/app/data/services/database.dart';
import 'package:listinhax/app/data/services/objectbox/product_box.dart';
import 'package:listinhax/app/domain/models/cart_item.dart';
import 'package:listinhax/app/domain/models/product.dart';

class ProductsRepository extends ChangeNotifier {
  final Database database;
  final List<CartItem> _cartItems = [];
  List<Product> _productsList = [];

  ProductsRepository({required this.database});

  UnmodifiableListView<CartItem> get cartItems =>
      UnmodifiableListView<CartItem>(_cartItems);
  UnmodifiableListView<Product> get products =>
      UnmodifiableListView<Product>(_productsList);

  Result<bool, String> addProduct(Product product) {
    try {
      _productsList.add(product);
      database.createProduct(product);
      notifyListeners();
      return Ok(true);
    } on DatabaseObException catch (_) {
      return Err('Erro ao inserir os dados. Tente novamente');
    }
  }

  Future<Result<List<Product>, String>> loadProducts() async {
    try {
      final productsData = database.loadProducts();
      _productsList = [];
      for (final ProductBox productData in productsData) {
        _productsList.add(productData.fromBox());
      }
      return Ok(products);
    } catch (_) {
      return Err('Erro ao carregar os produtos');
    }
  }

  void toggleCartItem(Product product) {
    final productIndex = _cartItems.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (productIndex >= 0) {
      _cartItems.removeAt(productIndex);
      notifyListeners();
      return;
    }

    _cartItems.add(
      CartItem(product: product, amount: 1),
    );
    notifyListeners();
  }

  void _changeAmount(CartItem cartItem, int amount) {
    final cartIndex = _cartItems.indexWhere(
      (item) => item.product.name == cartItem.product.name,
    );

    if (cartIndex < 0) {
      return;
    }

    _cartItems[cartIndex] = CartItem(product: cartItem.product, amount: amount);
    notifyListeners();
  }

  void increase(CartItem cartItem) {
    _changeAmount(cartItem, cartItem.amount + 1);
  }

  void decrease(CartItem cartItem) {
    final amount = (cartItem.amount == 0) ? 0 : cartItem.amount - 1;
    _changeAmount(cartItem, amount);
  }
}
