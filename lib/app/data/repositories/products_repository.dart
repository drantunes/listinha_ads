import 'dart:collection';

import 'package:listinhax/app/core/result.dart';
import 'package:listinhax/app/data/services/products_service.dart';
import 'package:listinhax/app/domain/models/cart_item.dart';
import 'package:listinhax/app/domain/models/product.dart';

class ProductsRepository {
  final ProductsApiService productsService;
  final List<CartItem> _cartItems = [];

  ProductsRepository({required this.productsService});

  UnmodifiableListView<CartItem> get cartItems =>
      UnmodifiableListView<CartItem>(_cartItems);

  Future<Result<List<Product>, String>> loadProducts() async {
    try {
      final products = await productsService.getProducts();
      return Ok(products);
    } catch (_) {
      return Err('Erro ao carregar os produtos');
    }
  }

  Future<Result<bool, String>> addProduct(Product product) async {
    try {
      await productsService.saveProduct(product);
      return Ok(true);
    } catch (_) {
      return Err('Erro ao inserir os dados. Tente novamente');
    }
  }

  void toggleCartItem(Product product) {
    final index = _cartItems.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (index >= 0) {
      _cartItems.removeAt(index);
    } else {
      _cartItems.add(CartItem(product: product, amount: 1));
    }
  }

  void _changeAmount(CartItem cartItem, int amount) {
    final index = _cartItems.indexWhere(
      (item) => item.product.name == cartItem.product.name,
    );
    if (index < 0) return;
    _cartItems[index] = CartItem(product: cartItem.product, amount: amount);
  }

  void increase(CartItem cartItem) {
    _changeAmount(cartItem, cartItem.amount + 1);
  }

  void decrease(CartItem cartItem) {
    final amount = cartItem.amount == 0 ? 0 : cartItem.amount - 1;
    _changeAmount(cartItem, amount);
  }
}
