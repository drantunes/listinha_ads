import 'dart:collection';

import 'package:listinhax/app/models/cart_item.dart';
import 'package:listinhax/app/models/product.dart';

class ProductsRepository {
  final List<CartItem> _cartItems = [];
  final List<Product> _productsList = [];

  UnmodifiableListView<CartItem> get cartItems => UnmodifiableListView(_cartItems);
  UnmodifiableListView<Product> get products => UnmodifiableListView(_productsList);

  void addProduct(Product product) {
    _productsList.add(product);
  }

  Future<List<Product>> loadProducts() async {
    // chamada à API ou BD
    await Future.delayed(Duration(seconds: 2));
    return products;
  }

  void addProductToCart(Product product) {
    _cartItems.add(
      CartItem(product: product, amount: 1),
    );
  }

  void toggleCartItem(Product product) {
    int productIndex = _cartItems.indexWhere((item) => item.product.name == product.name);

    if (productIndex >= 0) {
      _cartItems.removeAt(productIndex);
      return;
    }

    _cartItems.add(
      CartItem(product: product, amount: 1),
    );
  }

  void _changeAmount(CartItem cartItem, int amount) {
    int cartIndex = _cartItems.indexWhere(
      (item) => item.product.name == cartItem.product.name,
    );

    _cartItems[cartIndex] = CartItem(product: cartItem.product, amount: amount);
  }

  void increase(CartItem cartItem) {
    _changeAmount(cartItem, cartItem.amount + 1);
  }

  void decrease(CartItem cartItem) {
    final amount = (cartItem.amount == 0) ? 0 : cartItem.amount - 1;
    _changeAmount(cartItem, amount);
  }
}
