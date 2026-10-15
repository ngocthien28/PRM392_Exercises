import 'package:flutter/foundation.dart';

import 'student.dart';

/// Dữ liệu dùng chung giữa List, Detail và Form, chỉ lưu trong bộ nhớ.
class StudentStore extends ChangeNotifier {
  final List<Student> _students = [
    const Student(id: 'SV01', name: 'Nguyễn Văn A', age: 20),
    const Student(id: 'SV02', name: 'Trần Thị B', age: 21),
    const Student(id: 'SV03', name: 'Lê Văn C', age: 19),
  ];
  List<Student> get students => List.unmodifiable(_students);
  Student? find(String id) {
    for (final student in _students) {
      if (student.id == id) return student;
    }
    return null;
  }

  void save(Student student, {bool editing = false}) {
    if (student.id.trim().isEmpty ||
        student.name.trim().isEmpty ||
        student.age < 1 ||
        student.age > 120) {
      throw ArgumentError('Thông tin sinh viên không hợp lệ.');
    }
    final index = _students.indexWhere((item) => item.id == student.id);
    if (editing) {
      if (index < 0) throw StateError('Không tìm thấy sinh viên.');
      _students[index] = student;
    } else {
      if (index >= 0) throw StateError('Mã sinh viên đã tồn tại.');
      _students.add(student);
    }
    notifyListeners();
  }
}
