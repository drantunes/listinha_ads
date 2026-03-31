import 'package:flutter/material.dart';
import 'package:listinhax/app/features/cart_items/cart_items_screen.dart';
import 'package:listinhax/app/features/products/add_product_screen.dart';
import 'package:listinhax/app/models/product.dart';
import 'package:listinhax/app/repositories/products_repository.dart';
import 'package:listinhax/app/widgets/avatar.dart';
import 'package:listinhax/app/widgets/shopping_button.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  ProductsRepository? productsRepository;

  @override
  void initState() {
    super.initState();
    productsRepository = ProductsRepository();
    products = productsRepository!.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Avatar(),
        centerTitle: true,
        title: Text('Listinha'),
        actions: [
          ShoppingButton(
            count: productsRepository!.cartItems.length,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartItemsScreen(
                    productsRepository: productsRepository!,
                    onChange: () => setState(() {}),
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: products.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(products[index].name),
          trailing: Switch(
            value: productsRepository!.cartItems.any(
              (item) => item.product.name == products[index].name,
            ),
            onChanged: (val) {
              setState(() {
                productsRepository!.toggleCartItem(products[index]);
              });
            },
          ),
        ),
        separatorBuilder: (context, index) => Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddProductScreen(
                productsRepository: productsRepository!,
                onSave: updateProducts,
              ),
              fullscreenDialog: true,
            ),
          );
        },
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }

  void updateProducts() {
    setState(() {
      products = productsRepository!.loadProducts();
    });
  }
}
