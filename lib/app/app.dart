import 'package:flutter/material.dart';
import 'package:listinhax/app/data/repositories/products_repository.dart';
import 'package:listinhax/app/data/repositories/user_repository.dart';
import 'package:listinhax/app/providers/providers.dart';
import 'package:listinhax/app/routes.dart';
import 'package:listinhax/theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final ProductsRepository productsRepository;
  final UserRepository userRepository;

  const App({
    super.key,
    required this.productsRepository,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(productsRepository, userRepository),
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
