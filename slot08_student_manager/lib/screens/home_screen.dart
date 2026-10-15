import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Student Manager')),
    body: Center(
      child: FilledButton.icon(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.students),
        icon: const Icon(Icons.groups),
        label: const Text('Danh sách sinh viên'),
      ),
    ),
  );
}
