import 'package:flutter/material.dart';

import '../widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _tasks = [];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Daily Planner')),
    body: _tasks.isEmpty
        ? const Center(child: Text('Chưa có công việc. Nhấn + để thêm.'))
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _tasks.map((task) => TaskItem(title: task)).toList(),
            ),
          ),
    floatingActionButton: FloatingActionButton(
      tooltip: 'Thêm công việc',
      onPressed: () =>
          setState(() => _tasks.add('Công việc số ${_tasks.length + 1}')),
      child: const Icon(Icons.add),
    ),
  );
}
