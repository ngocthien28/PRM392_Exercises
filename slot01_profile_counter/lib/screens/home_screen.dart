import 'package:flutter/material.dart';

import '../widgets/hello_widget.dart';
import '../widgets/profile_card.dart';
import '../widgets/counter_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My First Flutter App')),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HelloWidget(),
          SizedBox(height: 16),
          ProfileCard(),
          SizedBox(height: 24),
          CounterWidget(),
        ],
      ),
    ),
  );
}
