import 'package:listinhax/app/models/product.dart';

class CartItem {
  final Product product;
  final int amount;

  CartItem({
    required this.product,
    required this.amount,
  });
}
