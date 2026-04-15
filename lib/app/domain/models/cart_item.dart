import 'package:listinhax/app/domain/models/product.dart';

class CartItem {
  final Product product;
  final int amount;

  CartItem({
    required this.product,
    required this.amount,
  });
}
