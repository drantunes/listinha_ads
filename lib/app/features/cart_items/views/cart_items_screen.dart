import 'package:flutter/material.dart';
import 'package:listinhax/app/features/cart_items/viewmodels/cart_items_view_model.dart';

class CartItemsScreen extends StatefulWidget {
  final CartItemsViewModel cartItemsViewModel;

  const CartItemsScreen({super.key, required this.cartItemsViewModel});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  CartItemsViewModel get _viewModel => widget.cartItemsViewModel;

  @override
  void initState() {
    super.initState();
    _viewModel.startSession();
  }

  @override
  Widget build(BuildContext context) {
    final vm = _viewModel;

    return ListenableBuilder(
      listenable: vm,
      builder: (context, child) {
        final cartItems = vm.cartItems;

        return Scaffold(
          appBar: AppBar(
            title: Text('Shopping Items'),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: vm.oldProgress, end: vm.currentProgress),
                      duration: Duration(milliseconds: 400),
                      builder: (context, value, _) {
                        return CircularProgressIndicator(
                          backgroundColor: Colors.teal[100],
                          value: value,
                        );
                      },
                    ),
                    Text(
                      vm.remainingItems.toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: (cartItems.isEmpty)
              ? Center(
                  child: Text('Não há items no carrinho'),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (val) {
                        if (val == true) {
                          vm.completeItem(cartItems[index]);
                        }
                      },
                    ),
                    title: Text(cartItems[index].product.name),
                    trailing: SizedBox(
                      width: 140,
                      child: Transform.scale(
                        scale: .7,
                        child: Row(
                          children: [
                            IconButton.filledTonal(
                              onPressed: () => vm.decrease(cartItems[index]),
                              icon: Icon(Icons.remove),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                cartItems[index].amount.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => vm.increase(cartItems[index]),
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (_, _) => Divider(),
                  itemCount: cartItems.length,
                ),
        );
      },
    );
  }
}
