import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listinhax/app/data/repositories/user_repository.dart';
import 'package:listinhax/app/features/products/viewmodels/products_view_model.dart';
import 'package:listinhax/app/routes.dart';
import 'package:listinhax/app/widgets/avatar.dart';
import 'package:listinhax/app/widgets/shopping_button.dart';
import 'package:listinhax/theme.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final ProductsViewModel productsViewModel;

  const ProductsScreen({super.key, required this.productsViewModel});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductsViewModel get _viewModel => widget.productsViewModel;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onFeedback);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onFeedback);
    super.dispose();
  }

  void _onFeedback() {
    if (!mounted || _viewModel.feedback.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_viewModel.feedback)),
    );
    _viewModel.clearFeedback();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _viewModel;
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Avatar(),
            centerTitle: true,
            title: vm.isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Carregando...'),
                      ),
                    ],
                  )
                : Text('Listinha'),
            actions: [
              ValueListenableBuilder(
                valueListenable: themeMode,
                builder: (context, theme, _) => IconButton(
                  onPressed: () => theme == ThemeMode.dark
                      ? themeMode.value = ThemeMode.light
                      : themeMode.value = ThemeMode.dark,
                  icon: Icon(
                    theme == ThemeMode.dark ? Icons.sunny : Icons.nightlight,
                  ),
                ),
              ),
              ShoppingButton(
                count: vm.cartItemsCount,
                onPressed: () => context.push(Routes.cartItems),
              ),
              TextButton(
                onPressed: () => context.read<UserRepository>().logout(),
                child: Text('Sair'),
              ),
            ],
          ),
          body: _buildBody(vm),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(Routes.addProducts),
            child: Icon(Icons.add_shopping_cart),
          ),
        );
      },
    );
  }

  Widget _buildBody(ProductsViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(vm.error, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    if (vm.products.isEmpty) {
      return const Center(child: Text('Nenhum produto cadastrado.'));
    }

    return ListView.separated(
      itemCount: vm.products.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(vm.products[index].name),
        trailing: Switch(
          value: vm.isInCart(vm.products[index]),
          onChanged: (_) => vm.toggleProductInCart(vm.products[index]),
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
