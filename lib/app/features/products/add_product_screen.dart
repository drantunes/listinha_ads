import 'package:flutter/material.dart';
import 'package:listinhax/app/models/product.dart';
import 'package:listinhax/app/repositories/products_repository.dart';

class AddProductScreen extends StatefulWidget {
  final ProductsRepository productsRepository;
  final void Function() onSave;

  const AddProductScreen({
    super.key,
    required this.productsRepository,
    required this.onSave,
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
      widget.productsRepository.addProduct(
        Product(
          name: productController.text,
        ),
      );
      widget.onSave();
      Navigator.of(context).pop();
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
