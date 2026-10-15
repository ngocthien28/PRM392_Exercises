import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/student_store.dart';
import 'student_form_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key, required this.id, required this.store});
  final String id;
  final StudentStore store;

  Future<void> _edit(BuildContext context, Student student) async {
    final updated = await Navigator.push<Student>(
      context,
      MaterialPageRoute(
        builder: (_) => StudentFormScreen(store: store, student: student),
      ),
    );
    if (updated != null) store.save(updated, editing: true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Chi tiết sinh viên')),
    body: ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final student = store.find(id);
        if (student == null) {
          return const Center(child: Text('Không tìm thấy sinh viên.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.account_circle, size: 80),
              Text(
                student.name,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('Mã sinh viên: ${student.id}'),
              Text('Tuổi: ${student.age}'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => _edit(context, student),
                child: const Text('Chỉnh sửa'),
              ),
            ],
          ),
        );
      },
    ),
  );
}
