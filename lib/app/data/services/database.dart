import 'package:listinhax/app/data/services/objectbox_database.dart';
import 'package:listinhax/app/domain/models/product.dart';
import 'package:pocketbase/pocketbase.dart';

class DatabaseObException implements Exception {
  String message;

  DatabaseObException(this.message);
}

class Database {
  final ObjectBoxDatabase objectBoxDatabase;

  Database({required this.objectBoxDatabase});

  Future<void> createProduct(Product product) async {
    try {
      // final productBox = objectBox!.store.box<ProductBox>();
      // productBox.put(ProductBox()..name = product.name);
      final pb = PocketBase('http://127.0.0.1:8090');
      final body = <String, dynamic>{"name": product.name};

      await pb.collection('products').create(body: body, files: []);
    } catch (_) {
      throw DatabaseObException('Erro ao Inserir os dados');
    }
  }

  Future<List<RecordModel>> loadProducts() async {
    try {
      // final productsBox = objectBox!.store.box<ProductBox>();
      // return productsBox.getAll();
      final pb = PocketBase('http://127.0.0.1:8090');
      return await pb.collection('products').getFullList();
    } catch (_) {
      throw DatabaseObException('Erro ao carregar os dados');
    }
  }
}
