import 'package:go_router/go_router.dart';
import 'package:listinhax/app/features/cart_items/viewmodels/cart_items_view_model.dart';
import 'package:listinhax/app/features/cart_items/views/cart_items_screen.dart';
import 'package:listinhax/app/features/products/viewmodels/products_view_model.dart';
import 'package:listinhax/app/features/products/views/add_product_screen.dart';
import 'package:listinhax/app/features/products/views/products_screen.dart';
import 'package:provider/provider.dart';

class Routes {
  static const products = '/products';
  static const addProducts = '/add-products';
  static const cartItems = '/cart-items';
}

final routes = GoRouter(
  initialLocation: Routes.products,
  routes: [
    GoRoute(
      path: Routes.products,
      name: Routes.products,
      builder: (context, state) => ProductsScreen(
        productsViewModel: context.read<ProductsViewModel>(),
      ),
    ),
    GoRoute(
      path: Routes.addProducts,
      name: Routes.addProducts,
      builder: (context, state) => AddProductScreen(
        productsViewModel: context.read<ProductsViewModel>(),
      ),
    ),
    GoRoute(
      path: Routes.cartItems,
      name: Routes.cartItems,
      builder: (context, state) => CartItemsScreen(
        cartItemsViewModel: context.read<CartItemsViewModel>(),
      ),
    ),
  ],
);
