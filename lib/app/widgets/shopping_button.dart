import 'package:flutter/material.dart';

class ShoppingButton extends StatelessWidget {
  final int count;
  final Function()? onPressed;

  const ShoppingButton({
    super.key,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Badge.count(
        count: count,
        isLabelVisible: count > 0 ? true : false,
        padding: EdgeInsets.all(2),
        offset: Offset(-5, 5),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
