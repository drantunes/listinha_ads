import 'package:flutter/material.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/providers/providers.dart';
import 'package:listinhax/app/routes.dart';
import 'package:listinhax/theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final ProductsRepository productsRepository;
  const App({super.key, required this.productsRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(productsRepository),
      child: ValueListenableBuilder(
        valueListenable: themeMode,
        builder: (context, theme, _) {
          return MaterialApp.router(
            title: 'Listinha',
            debugShowCheckedModeBanner: false,
            theme: (theme == ThemeMode.dark) ? darkTheme : lightTheme,
            routerConfig: routes,
          );
        },
      ),
    );
  }
}
