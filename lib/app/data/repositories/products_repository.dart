import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:listinhax/app/core/result.dart';
import 'package:listinhax/app/data/services/database.dart';
import 'package:listinhax/app/domain/models/cart_item.dart';
import 'package:listinhax/app/domain/models/product.dart';

class ProductsRepository extends ChangeNotifier {
  final Database database;
  final List<CartItem> _cartItems = [];
  List<Product> _productsList = [];

  // Realtime stream fields
  late final Stream<List<Product>> productsStream;
  StreamSubscription<List<Product>>? _subscription;

  ProductsRepository({required this.database}) {
    // Expose the database stream and listen internally to keep
    // _productsList in sync (needed by cart-related methods).
    productsStream = database.watchProducts();
    _subscription = productsStream.listen(
      (products) {
        _productsList = products;
        notifyListeners();
      },
      onError: (_) {
        // Errors surface through the stream; nothing extra needed here.
      },
    );
  }

  UnmodifiableListView<CartItem> get cartItems =>
      UnmodifiableListView<CartItem>(_cartItems);

  UnmodifiableListView<Product> get products =>
      UnmodifiableListView<Product>(_productsList);

  Result<bool, String> addProduct(Product product) {
    try {
      //_productsList.add(product);
      database.createProduct(product);
      //notifyListeners();
      return Ok(true);
    } on DatabaseObException catch (_) {
      return Err('Erro ao inserir os dados. Tente novamente');
    }
  }

  // Future<Result<List<Product>, String>> loadProducts() async {
  //   try {
  //     final productsData = await database.loadProducts();
  //     _productsList = [];
  //     for (final RecordModel product in productsData) {
  //       _productsList.add(Product(name: product.data['name']));
  //     }
  //     return Ok(products);
  //   } catch (_) {
  //     return Err('Erro ao carregar os produtos');
  //   }
  // }

  void toggleCartItem(Product product) {
    final productIndex = _cartItems.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (productIndex >= 0) {
      _cartItems.removeAt(productIndex);
      notifyListeners();
      return;
    }

    _cartItems.add(CartItem(product: product, amount: 1));
    notifyListeners();
  }

  void _changeAmount(CartItem cartItem, int amount) {
    final cartIndex = _cartItems.indexWhere(
      (item) => item.product.name == cartItem.product.name,
    );

    if (cartIndex < 0) return;

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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
