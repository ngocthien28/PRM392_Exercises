import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot06_student_list/main.dart';

void main() {
  testWidgets('Selection toggles independently and can be reversed', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(Card), findsNWidgets(5));
    expect(find.text('Đã chọn: 0/5'), findsOneWidget);
    await tester.tap(find.text('SV01'));
    await tester.pump();
    await tester.tap(find.text('SV02'));
    await tester.pump();
    expect(find.text('Đã chọn: 2/5'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
    await tester.tap(find.text('SV01'));
    await tester.pump();
    expect(find.text('Đã chọn: 1/5'), findsOneWidget);
  });

  testWidgets('List scrolls on a short screen and retains selection', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('SV01'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('SV05'), 100);
    await tester.ensureVisible(find.byKey(const ValueKey('SV05')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SV05'));
    await tester.pump();
    expect(find.text('Đã chọn: 2/5'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('SV01'), -100);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ListTile>(
            find.ancestor(
              of: find.text('SV01'),
              matching: find.byType(ListTile),
            ),
          )
          .selected,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
