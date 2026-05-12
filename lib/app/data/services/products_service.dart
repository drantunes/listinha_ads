import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listinhax/app/domain/models/product.dart';

const url = 'https://62d205d2dccad0cf17705a26.mockapi.io/';

class ProductsApiService {
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$url/products'));

      if (response.statusCode == 200) {
        final List<Product> products = [];
        final body = jsonDecode(response.body) as List;

        for (var map in body) {
          products.add(Product(name: map['name']));
        }

        return products;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> saveProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$url/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': product.name}),
      );

      if (response.statusCode != 201) {
        throw Exception('Falhou: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao salvar o produto: ${e.toString()}');
    }
  }
}
