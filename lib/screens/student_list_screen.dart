import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/student_store.dart';
import '../routes/app_routes.dart';
import '../widgets/student_tile.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key, required this.store});
  final StudentStore store;

  Future<void> _add(BuildContext context) async {
    final student = await Navigator.push<Student>(
      context,
      MaterialPageRoute(builder: (_) => StudentFormScreen(store: store)),
    );
    if (student != null) store.save(student);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Danh sách sinh viên')),
    body: ListenableBuilder(
      listenable: store,
      builder: (context, _) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: store.students.length,
        itemBuilder: (context, index) => StudentTile(
          student: store.students[index],
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.detail,
            arguments: store.students[index],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      tooltip: 'Thêm sinh viên',
      onPressed: () => _add(context),
      child: const Icon(Icons.add),
    ),
  );
}
