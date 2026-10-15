import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot07_simple_planner/main.dart';

Future<void> openForm(WidgetTester tester) async {
  await tester.tap(find.text('Tạo kế hoạch mới'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Empty form cannot save; back does not create a plan', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openForm(tester);
    await tester.tap(find.text('Lưu kế hoạch'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập tiêu đề.'), findsOneWidget);
    expect(find.text('Vui lòng chọn ngày và giờ.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Chưa có kế hoạch.'), findsOneWidget);
  });

  testWidgets('Date and time pickers return a plan to Home', (tester) async {
    await tester.pumpWidget(const MyApp());
    await openForm(tester);
    await tester.enterText(
      find.byKey(const Key('planTitle')),
      '  Ôn tập Flutter  ',
    );
    await tester.tap(find.byKey(const Key('pickDate')));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pickTime')));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu kế hoạch'));
    await tester.pumpAndSettle();
    expect(find.text('Simple Planner'), findsOneWidget);
    expect(find.text('Ôn tập Flutter'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Canceling a picker does not silently select a date', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openForm(tester);
    await tester.tap(find.byKey(const Key('pickDate')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Chọn ngày'), findsOneWidget);
  });
}
