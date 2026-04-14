import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listinhax/app/features/products/products_viewmodel.dart';
import 'package:listinhax/app/routes.dart';
import 'package:listinhax/app/widgets/avatar.dart';
import 'package:listinhax/app/widgets/shopping_button.dart';
import 'package:listinhax/theme.dart';

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

  double size = 50;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: .center,
    //       crossAxisAlignment: .center,
    //       children: [
    //         InkWell(
    //           onTap: () => Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) => Scaffold(
    //                 appBar: AppBar(
    //                   actions: [
    //                     Hero(
    //                       tag: 'image1',
    //                       child: CircleAvatar(
    //                         child: Image.asset('assets/images/profile.png'),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           child: SizedBox(
    //             width: 200,
    //             child: Hero(
    //               tag: 'image1',
    //               child: Image.asset('assets/images/profile.png'),
    //             ),
    //           ),
    //         ),
    //         AnimatedSwitcher(
    //           duration: Duration(milliseconds: 300),
    //           transitionBuilder: (child, animation) => RotationTransition(
    //             turns: animation,
    //             child: child,
    //           ),
    //           child: Text(
    //             key: ValueKey(size),
    //             size.toStringAsFixed(0),
    //             style: Theme.of(context).textTheme.headlineLarge,
    //           ),
    //         ),
    //         InkWell(
    //           onTap: () => setState(() => size += 50),
    //           child: AnimatedContainer(
    //             duration: Duration(milliseconds: 300),
    //             width: size,
    //             height: size,
    //             color: switch (size) {
    //               50 => Colors.amber,
    //               100 => Colors.red,
    //               150 => Colors.blue,
    //               200 => Colors.green,
    //               _ => Colors.pink,
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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
              ValueListenableBuilder(
                valueListenable: themeMode,
                builder: (context, theme, _) => IconButton(
                  onPressed: () => theme == ThemeMode.dark
                      ? themeMode.value = ThemeMode.light
                      : themeMode.value = ThemeMode.dark,
                  icon: Icon(theme == ThemeMode.dark ? Icons.sunny : Icons.nightlight),
                ),
              ),
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
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () => context.push(Routes.addProducts),

                child: Icon(Icons.add_shopping_cart),
              );
            },
          ),
        );
      },
    );
  }
}
