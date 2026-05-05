import 'package:flutter/material.dart';
import 'package:listinhax/app/app.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/data/repositories/user_repository.dart';
import 'package:listinhax/app/data/services/auth_service.dart';
import 'package:listinhax/app/data/services/database.dart';
import 'package:listinhax/app/data/services/objectbox_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final objectBoxDatabase = await startObjectBox();
  final database = Database(objectBoxDatabase: objectBoxDatabase);

  final userRepository = UserRepository(AuthService());
  await userRepository.checkIfUserIsLoggedIn();

  final productsRepository = ProductsRepository(database: database);

  runApp(
    App(
      productsRepository: productsRepository,
      userRepository: userRepository,
    ),
  );
}
