import 'package:flutter/material.dart';
import 'package:listinhax/app/app.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/data/services/database.dart';
import 'package:listinhax/app/data/services/objectbox_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final objectBoxDatabase = await startObjectBox();
  final database = Database(objectBoxDatabase: objectBoxDatabase);

  final productsRepository = ProductsRepository(database: database);

  runApp(
    App(productsRepository: productsRepository),
  );
}
