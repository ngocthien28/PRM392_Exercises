import 'package:flutter/material.dart';

class ResponsiveProductGrid extends StatelessWidget {
  const ResponsiveProductGrid({super.key});

  static int columnsFor(double width) =>
      width < 600 ? 2 : (width < 900 ? 3 : 4);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
      return GridView.builder(
        key: const Key('responsiveGrid'),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnsFor(constraints.maxWidth),
          mainAxisExtent: 140 + (scale - 1) * 80,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) => Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 32),
                const SizedBox(height: 12),
                Text(
                  'Sản phẩm ${index + 1}',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
