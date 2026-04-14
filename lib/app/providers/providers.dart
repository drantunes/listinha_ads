import 'package:listinhax/app/features/products/products_viewmodel.dart';
import 'package:listinhax/app/repositories/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers(ProductsRepository productsRepository) {
  return [
    Provider.value(value: productsRepository),
    ChangeNotifierProvider<ProductsViewmodel>(
      create: (context) => ProductsViewmodel(
        productsRepository: context.read(),
      ),
    ),
  ];
}
