import 'package:flutter/material.dart';

import '../widgets/summary_card.dart';
import '../widgets/responsive_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final padding = (width * .04).clamp(12.0, 40.0);
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Dashboard')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: (width * .06).clamp(20.0, 32.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.dashboard_outlined),
                ],
              ),
              const SizedBox(height: 20),
              const SummarySection(),
              const SizedBox(height: 24),
              Text(
                'Danh mục sản phẩm',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const ResponsiveProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const first = SummaryCard(
        title: 'Sản phẩm',
        value: '12',
        icon: Icons.inventory_2_outlined,
      );
      const second = SummaryCard(
        title: 'Lượt xem',
        value: '1.280',
        icon: Icons.visibility_outlined,
      );
      final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
      if (constraints.maxWidth < 600 * scale) {
        return const Column(
          key: Key('summaryColumn'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [first, SizedBox(height: 8), second],
        );
      }
      return const Row(
        key: Key('summaryRow'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          SizedBox(width: 12),
          Expanded(child: second),
        ],
      );
    },
  );
}
