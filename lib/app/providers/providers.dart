import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/data/repositories/user_repository.dart';
import 'package:listinhax/app/features/cart_items/viewmodels/cart_items_view_model.dart';
import 'package:listinhax/app/features/products/viewmodels/products_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers(
  ProductsRepository productsRepository,
  UserRepository userRepository,
) {
  return [
    Provider<UserRepository>.value(value: userRepository),
    ChangeNotifierProvider<ProductsRepository>.value(value: productsRepository),
    ChangeNotifierProvider<ProductsViewModel>(
      create: (context) => ProductsViewModel(
        productsRepository: context.read(),
      )..load(),
    ),
    ChangeNotifierProvider<CartItemsViewModel>(
      create: (context) => CartItemsViewModel(
        productsRepository: context.read(),
      ),
    ),
  ];
}
