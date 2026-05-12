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
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          leading: const Avatar(),
          centerTitle: true,
          title: _viewModel.isLoading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Carregando...'),
                    ),
                  ],
                )
              : const Text('Listinha'),
          actions: [
            ValueListenableBuilder(
              valueListenable: themeMode,
              builder: (context, theme, _) => IconButton(
                onPressed: () => themeMode.value =
                    theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                icon: Icon(
                  theme == ThemeMode.dark ? Icons.sunny : Icons.nightlight,
                ),
              ),
            ),
            ShoppingButton(
              count: _viewModel.cartItemsCount,
              onPressed: () => context.push(Routes.cartItems),
            ),
            TextButton(
              onPressed: () => context.read<UserRepository>().logout(),
              child: const Text('Sair'),
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(Routes.addProducts),
          child: const Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(_viewModel.error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _viewModel.load,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_viewModel.products.isEmpty) {
      return const Center(child: Text('Nenhum produto cadastrado.'));
    }

    return RefreshIndicator(
      onRefresh: _viewModel.load,
      child: ListView.separated(
        itemCount: _viewModel.products.length,
        itemBuilder: (context, index) {
          final product = _viewModel.products[index];
          return ListTile(
            title: Text(product.name),
            trailing: Switch(
              value: _viewModel.isInCart(product),
              onChanged: (_) => _viewModel.toggleProductInCart(product),
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}
