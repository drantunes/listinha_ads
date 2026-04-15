import 'package:flutter/material.dart';
import 'package:listinhax/app/app.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';

void main() {
  final productsRepository = ProductsRepository();

  runApp(
    App(productsRepository: productsRepository),
  );
}
