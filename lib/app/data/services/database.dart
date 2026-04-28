import 'package:listinhax/app/data/services/objectbox/product_box.dart';
import 'package:listinhax/app/data/services/objectbox_database.dart';
import 'package:listinhax/app/domain/models/product.dart';

class DatabaseObException implements Exception {
  String message;

  DatabaseObException(this.message);
}

class Database {
  final ObjectBoxDatabase objectBoxDatabase;

  Database({required this.objectBoxDatabase});

  void createProduct(Product product) {
    try {
      final productBox = objectBox!.store.box<ProductBox>();
      productBox.put(ProductBox()..name = product.name);
    } catch (_) {
      throw DatabaseObException('Erro ao Inserir os dados');
    }
  }

  List<ProductBox> loadProducts() {
    try {
      final productsBox = objectBox!.store.box<ProductBox>();
      return productsBox.getAll();
    } catch (_) {
      throw DatabaseObException('Erro ao carregar os dados');
    }
  }
}
