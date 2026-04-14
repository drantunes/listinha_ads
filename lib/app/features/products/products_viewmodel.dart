import 'package:flutter/material.dart';
import 'package:listinhax/app/models/cart_item.dart';
import 'package:listinhax/app/models/product.dart';
import 'package:listinhax/app/repositories/products_repository.dart';
import 'package:listinhax/app/utils/result.dart';

class ProductsViewmodel extends ChangeNotifier {
  bool isLoading = false;
  List<Product> products = [];
  final ProductsRepository productsRepository;
  String feedback = '';

  ProductsViewmodel({required this.productsRepository});

  void load() async {
    isLoading = true;
    feedback = '';
    notifyListeners();

    final result = await productsRepository.loadProducts();
    switch (result) {
      case Ok():
        products = result.value;
        isLoading = false;
        notifyListeners();
      case Err():
        debugPrint(result.value);
    }
  }

  void saveProduct(String productName) {
    productsRepository.addProduct(Product(name: productName));
    feedback = '$productName foi salvo!';
    notifyListeners();
    load();
  }

  void toggleCartItem(Product product) {
    productsRepository.toggleCartItem(product);
    notifyListeners();
  }

  void decrease(CartItem cartItem) {
    productsRepository.decrease(cartItem);
  }

  void increase(CartItem cartItem) {
    productsRepository.increase(cartItem);
  }
}
