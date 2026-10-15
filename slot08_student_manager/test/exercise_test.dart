import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot08_student_manager/main.dart';
import 'package:slot08_student_manager/routes/app_routes.dart';
import 'package:slot08_student_manager/models/student.dart';
import 'package:slot08_student_manager/models/student_store.dart';

Future<void> openList(WidgetTester tester) async {
  await tester.tap(find.text('Danh sách sinh viên'));
  await tester.pumpAndSettle();
}

Future<void> fillForm(
  WidgetTester tester,
  String id,
  String name,
  String age,
) async {
  await tester.enterText(find.byKey(const Key('studentId')), id);
  await tester.enterText(find.byKey(const Key('studentName')), name);
  await tester.enterText(find.byKey(const Key('studentAge')), age);
}

void main() {
  testWidgets(
    'Warm platform links normalize URI and navigate to the correct student',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.binding.handlePushRoute('studentapp://student/SV02');
      await tester.pumpAndSettle();
      expect(find.text('Mã sinh viên: SV02'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Student Manager'), findsOneWidget);
      await tester.binding.handlePushRoute(
        'studentapp://student/detail?id=SV01',
      );
      await tester.pumpAndSettle();
      expect(find.text('Mã sinh viên: SV01'), findsOneWidget);
    },
  );
  test(
    'Deep link parser accepts supported links and rejects unrelated URIs',
    () {
      expect(
        AppRoutes.studentIdFromLink('studentapp://student/detail?id=SV01'),
        'SV01',
      );
      expect(AppRoutes.studentIdFromLink('studentapp://student/SV02'), 'SV02');
      expect(AppRoutes.studentIdFromLink('/student/SV03'), 'SV03');
      expect(AppRoutes.studentIdFromLink('/detail?id=SV01'), 'SV01');
      expect(
        AppRoutes.studentIdFromLink('https://evil.example/student/SV01'),
        isNull,
      );
      expect(AppRoutes.studentIdFromLink('/detail?id='), isNull);
      expect(AppRoutes.studentIdFromLink('/unknown'), isNull);
    },
  );

  test(
    'Store rejects duplicate IDs and invalid ages, updates existing records',
    () {
      final store = StudentStore();
      addTearDown(store.dispose);
      expect(
        () => store.save(const Student(id: 'SV01', name: 'Trùng', age: 20)),
        throwsStateError,
      );
      expect(
        () => store.save(const Student(id: 'NEW', name: 'Test', age: 0)),
        throwsArgumentError,
      );
      final edited = store.find('SV01')!.copyWith(name: 'Đã sửa');
      store.save(edited, editing: true);
      expect(store.find('SV01')!.name, 'Đã sửa');
      expect(store.students.length, 3);
    },
  );

  testWidgets('Create, detail, edit and back update the same student', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openList(tester);
    await tester.tap(find.byTooltip('Thêm sinh viên'));
    await tester.pumpAndSettle();
    await fillForm(tester, 'SV04', '  Mai Anh  ', '22');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Mai Anh'), findsOneWidget);
    await tester.tap(find.text('Mai Anh'));
    await tester.pumpAndSettle();
    expect(find.text('Mã sinh viên: SV04'), findsOneWidget);
    await tester.tap(find.text('Chỉnh sửa'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.byKey(const Key('studentId')),
              matching: find.byType(TextField),
            ),
          )
          .readOnly,
      isTrue,
    );
    await tester.enterText(
      find.byKey(const Key('studentName')),
      'Mai Anh Updated',
    );
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Mai Anh Updated'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Mai Anh Updated'), findsOneWidget);
    expect(find.text('Mai Anh'), findsNothing);
  });

  testWidgets('Form rejects missing fields, duplicate ID and noninteger age', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openList(tester);
    await tester.tap(find.byTooltip('Thêm sinh viên'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập mã sinh viên.'), findsOneWidget);
    await fillForm(tester, 'SV01', 'Test', 'abc');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Mã sinh viên đã tồn tại.'), findsOneWidget);
    expect(find.text('Tuổi phải là số nguyên từ 1 đến 120.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Test'), findsNothing);
  });

  testWidgets('Cold deep link opens detail and Back returns to Home', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(initialRoute: 'studentapp://student/detail?id=SV01'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Mã sinh viên: SV01'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Student Manager'), findsOneWidget);
  });

  testWidgets(
    'Unknown student and malformed route have safe fallback screens',
    (tester) async {
      await tester.pumpWidget(const MyApp(initialRoute: '/student/MISSING'));
      await tester.pumpAndSettle();
      expect(find.text('Không tìm thấy sinh viên.'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(const MyApp(initialRoute: '/detail'));
      await tester.pumpAndSettle();
      expect(
        find.text('Đường dẫn hoặc dữ liệu điều hướng không hợp lệ.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
