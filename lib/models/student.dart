class Student {
  const Student({required this.id, required this.name, required this.age});
  final String id;
  final String name;
  final int age;

  Student copyWith({String? id, String? name, int? age}) =>
      Student(id: id ?? this.id, name: name ?? this.name, age: age ?? this.age);
}
