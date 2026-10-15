import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, required this.onTap});
  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      selected: student.isSelected,
      leading: CircleAvatar(
        child: Text(student.name.isEmpty ? '?' : student.name.characters.first),
      ),
      title: Text(student.name),
      subtitle: Text(student.id),
      trailing: Icon(
        student.isSelected ? Icons.check_circle : Icons.circle_outlined,
        semanticLabel: student.isSelected ? 'Đã chọn' : 'Chưa chọn',
      ),
      onTap: onTap,
    ),
  );
}
