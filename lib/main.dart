import 'package:flutter/material.dart';
import 'package:listinhax/app/app.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/data/repositories/user_repository.dart';
import 'package:listinhax/app/data/services/auth_service.dart';
import 'package:listinhax/app/data/services/products_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userRepository = UserRepository(AuthService());
  await userRepository.checkIfUserIsLoggedIn();

  final productsRepository = ProductsRepository(
    productsService: ProductsApiService(),
  );

  runApp(
    App(
      productsRepository: productsRepository,
      userRepository: userRepository,
    ),
  );
}
