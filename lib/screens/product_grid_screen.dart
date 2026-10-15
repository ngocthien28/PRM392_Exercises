import 'package:flutter/material.dart';

import '../widgets/product_card.dart';

class ProductGridScreen extends StatelessWidget {
  const ProductGridScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sản phẩm')),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 180).floor().clamp(1, 6);
        final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: 30,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: 200 + (scale - 1) * 70,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) => ProductCard(index: index),
        );
      },
    ),
  );
}
