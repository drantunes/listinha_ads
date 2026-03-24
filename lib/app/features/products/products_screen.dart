import 'package:flutter/material.dart';
import 'package:listinhax/app/widgets/avatar.dart';
import 'package:listinhax/app/widgets/shopping_button.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Avatar(),
        centerTitle: true,
        title: Text('Listinha'),
        actions: [
          ShoppingButton(
            count: 3,
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 5,
        itemBuilder: (context, index) => ListTile(
          title: Text('Produto $index'),
          trailing: Switch(
            value: true,
            onChanged: (val) {},
          ),
        ),
        separatorBuilder: (context, index) => Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
