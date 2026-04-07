import 'package:flutter/material.dart';
import 'package:listinhax/app/features/products/products_viewmodel.dart';
import 'package:listinhax/app/repositories/products_repository.dart';
import 'package:listinhax/app/routes.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final ProductsRepository productsRepository;
  const App({super.key, required this.productsRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: productsRepository),
        ChangeNotifierProvider<ProductsViewmodel>(
          create: (context) => ProductsViewmodel(
            productsRepository: context.read(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Listinha',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
              ),
            ),
            routerConfig: routes,
          );
        },
      ),
    );
  }
}
