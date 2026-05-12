import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listinhax/app/features/products/viewmodels/products_view_model.dart';

class AddProductScreen extends StatefulWidget {
  final ProductsViewModel productsViewModel;

  const AddProductScreen({super.key, required this.productsViewModel});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _productController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await widget.productsViewModel.saveProduct(_productController.text);

    if (mounted) {
      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.shopping_cart),
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Nome do Produto',
                  contentPadding: EdgeInsets.all(24),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo nome é obrigatório';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check),
                              SizedBox(width: 10),
                              Text('Salvar', style: TextStyle(fontSize: 22)),
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
