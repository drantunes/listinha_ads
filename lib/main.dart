import 'package:flutter/material.dart';
import 'package:listinhax/app/app.dart';
import 'package:listinhax/app/repositories/products_repository.dart';

void main() {
  final productsRepository = ProductsRepository();
  productsRepository.loadProducts();

  runApp(App(productsRepository: productsRepository));
}
