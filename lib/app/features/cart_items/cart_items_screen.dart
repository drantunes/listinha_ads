import 'package:flutter/material.dart';

class CartItemsScreen extends StatelessWidget {
  const CartItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Items'),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.close)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: CircularProgressIndicator(
              value: 1,
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          leading: Checkbox(value: false, onChanged: (val) {}),
          title: Text('Produto $index'),
          trailing: IconButton.filled(onPressed: () {}, icon: Icon(Icons.add)),
        ),
        separatorBuilder: (_, _) => Divider(),
        itemCount: 3,
      ),
    );
  }
}
