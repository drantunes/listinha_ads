import 'package:listinhax/app/domain/models/product.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProductBox {
  @Id()
  int id = 0;
  String name = '';

  Product fromBox() {
    return Product(
      id: id.toString(),
      name: name,
    );
  }
}
