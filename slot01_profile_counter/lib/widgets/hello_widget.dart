import 'package:flutter/material.dart';

class HelloWidget extends StatelessWidget {
  const HelloWidget({super.key});

  @override
  Widget build(BuildContext context) => Text(
    'Xin chào, Flutter!',
    style: Theme.of(context).textTheme.headlineSmall,
  );
}
