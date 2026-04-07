import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listinhax/app/features/products/products_viewmodel.dart';
import 'package:listinhax/app/routes.dart';
import 'package:listinhax/app/widgets/avatar.dart';
import 'package:listinhax/app/widgets/shopping_button.dart';

class ProductsScreen extends StatefulWidget {
  final ProductsViewmodel productsViewmodel;

  const ProductsScreen({super.key, required this.productsViewmodel});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    widget.productsViewmodel.addListener(onSave);
    super.initState();
  }

  @override
  void dispose() {
    widget.productsViewmodel.removeListener(onSave);
    super.dispose();
  }

  void onSave() {
    if (widget.productsViewmodel.feedback.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.productsViewmodel.feedback)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.productsViewmodel;
    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Avatar(),
            centerTitle: true,
            title: (vm.isLoading)
                ? Row(
                    mainAxisAlignment: .center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Loading'),
                      ),
                    ],
                  )
                : Text('Listinha'),

            actions: [
              ShoppingButton(
                count: vm.productsRepository.cartItems.length,
                onPressed: () => context.push(Routes.cartItems),
              ),
            ],
          ),

          body: ListView.separated(
            itemCount: vm.products.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(vm.products[index].name),
              trailing: Switch(
                value: vm.productsRepository.cartItems.any(
                  (item) => item.product.name == vm.products[index].name,
                ),
                onChanged: (val) {
                  // setState(() {
                  vm.toggleCartItem(vm.products[index]);
                  // });
                },
              ),
            ),
            separatorBuilder: (context, index) => Divider(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(Routes.addProducts),
            child: Icon(Icons.add_shopping_cart),
          ),
        );
      },
    );
  }
}
