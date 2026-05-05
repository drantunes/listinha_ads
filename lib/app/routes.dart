import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listinhax/app/data/repositories/user_repository.dart';
import 'package:listinhax/app/features/cart_items/viewmodels/cart_items_view_model.dart';
import 'package:listinhax/app/features/cart_items/views/cart_items_screen.dart';
import 'package:listinhax/app/features/login/login_screen.dart';
import 'package:listinhax/app/features/login/login_viewmodel.dart';
import 'package:listinhax/app/features/products/viewmodels/products_view_model.dart';
import 'package:listinhax/app/features/products/views/add_product_screen.dart';
import 'package:listinhax/app/features/products/views/products_screen.dart';
import 'package:provider/provider.dart';

class Routes {
  static const products = '/products';
  static const addProducts = '/add-products';
  static const cartItems = '/cart-items';
  static const login = '/login';
  static const splash = '/loading';
}

final routes = GoRouter(
  initialLocation: Routes.products,
  refreshListenable: authState,
  redirect: (context, state) {
    return switch (authState.value) {
      AuthStatus.idle => Routes.splash,
      AuthStatus.loggedOut => Routes.login,
      AuthStatus.loggedIn => Routes.products,
      AuthStatus.online => (state.name == Routes.splash) ? Routes.products : null,
    };
  },
  routes: [
    GoRoute(
      name: Routes.login,
      path: Routes.login,
      builder: (context, state) {
        final loginViewModel = LoginViewmodel(userRepository: context.read());
        return LoginScreen(loginViewmodel: loginViewModel);
      },
    ),
    GoRoute(
      name: Routes.splash,
      path: Routes.splash,
      builder: (context, state) => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
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
