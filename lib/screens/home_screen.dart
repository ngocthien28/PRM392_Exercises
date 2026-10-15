import 'package:flutter/material.dart';

import '../models/student.dart';
import '../widgets/student_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _students = [
    Student(id: 'SV01', name: 'Nguyễn Văn A'),
    Student(id: 'SV02', name: 'Trần Thị B'),
    Student(id: 'SV03', name: 'Lê Văn C'),
    Student(id: 'SV04', name: 'Phạm Văn D'),
    Student(id: 'SV05', name: 'Hoàng Thị E'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Student List')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Đã chọn: ${_students.where((student) => student.isSelected).length}/${_students.length}',
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _students.length,
            itemBuilder: (context, index) {
              final student = _students[index];
              return StudentCard(
                key: ValueKey(student.id),
                student: student,
                onTap: () =>
                    setState(() => student.isSelected = !student.isSelected),
              );
            },
          ),
        ),
      ],
    ),
  );
}
