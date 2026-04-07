import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listinhax/app/features/products/products_viewmodel.dart';

class AddProductScreen extends StatefulWidget {
  final ProductsViewmodel productsViewmodel;

  const AddProductScreen({
    super.key,
    required this.productsViewmodel,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formkey = GlobalKey<FormState>();
  final productController = TextEditingController();

  @override
  void dispose() {
    productController.dispose();
    super.dispose();
  }

  void save() {
    if (formkey.currentState!.validate()) {
      widget.productsViewmodel.saveProduct(
        productController.text,
      );
      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              TextFormField(
                controller: productController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.shopping_cart),
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Nome do Produto',
                  contentPadding: EdgeInsets.all(24),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'O campo nome é obrigatório';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: FilledButton(
                  onPressed: save,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 10),
                        Text(
                          'Salvar',
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
