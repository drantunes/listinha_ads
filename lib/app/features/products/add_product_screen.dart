import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.shopping_cart),
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'Nome do Produto',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: FilledButton(
                onPressed: () {},
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
    );
  }
}
