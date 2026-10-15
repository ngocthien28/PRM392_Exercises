import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/student_store.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key, required this.store, this.student});
  final StudentStore store;
  final Student? student;
  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _id;
  late final TextEditingController _name;
  late final TextEditingController _age;

  @override
  void initState() {
    super.initState();
    _id = TextEditingController(text: widget.student?.id);
    _name = TextEditingController(text: widget.student?.name);
    _age = TextEditingController(text: widget.student?.age.toString());
  }

  @override
  void dispose() {
    _id.dispose();
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Student(
        id: _id.text.trim(),
        name: _name.text.trim(),
        age: int.parse(_age.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.student == null ? 'Thêm sinh viên' : 'Sửa sinh viên'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const Key('studentId'),
              controller: _id,
              readOnly: widget.student != null,
              decoration: const InputDecoration(labelText: 'Mã sinh viên'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập mã sinh viên.';
                }
                if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value.trim())) {
                  return 'Mã chỉ gồm chữ, số, _ hoặc -.';
                }
                if (widget.student == null &&
                    widget.store.find(value.trim()) != null) {
                  return 'Mã sinh viên đã tồn tại.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('studentName'),
              controller: _name,
              decoration: const InputDecoration(labelText: 'Họ tên'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập họ tên.'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('studentAge'),
              controller: _age,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tuổi'),
              validator: (value) {
                final age = int.tryParse(value?.trim() ?? '');
                return age == null || age < 1 || age > 120
                    ? 'Tuổi phải là số nguyên từ 1 đến 120.'
                    : null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Lưu')),
          ],
        ),
      ),
    ),
  );
}
