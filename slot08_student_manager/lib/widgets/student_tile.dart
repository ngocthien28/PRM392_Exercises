import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({super.key, required this.student, required this.onTap});
  final Student student;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    leading: const CircleAvatar(child: Icon(Icons.person_outline)),
    title: Text(student.name),
    subtitle: Text('${student.id} • ${student.age} tuổi'),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
