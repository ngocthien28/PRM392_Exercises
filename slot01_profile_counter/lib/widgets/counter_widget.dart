import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Bộ đếm'),
          Text(
            '$_count',
            key: const Key('counter'),
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Wrap(
            spacing: 16,
            alignment: WrapAlignment.center,
            children: [
              IconButton.filledTonal(
                key: const Key('decrement'),
                tooltip: 'Giảm',
                onPressed: () => setState(() => _count--),
                icon: const Icon(Icons.remove),
              ),
              IconButton.filled(
                key: const Key('increment'),
                tooltip: 'Tăng',
                onPressed: () => setState(() => _count++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
