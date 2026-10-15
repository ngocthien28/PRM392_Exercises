import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.inventory_2_outlined, size: 42),
                ),
                if (index % 3 == 0)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.amber),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('MỚI'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sản phẩm ${index + 1}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${(index + 1) * 10000} VND',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
