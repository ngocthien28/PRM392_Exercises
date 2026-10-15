import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot01_profile_counter/main.dart';

void main() {
  testWidgets(
    'Profile and greeting are visible; counter increments and decrements',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Nguyễn Văn A'), findsOneWidget);
      expect(find.text('Xin chào, Flutter!'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '0');
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pump();
      expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '1');
      await tester.tap(find.byKey(const Key('decrement')));
      await tester.tap(find.byKey(const Key('decrement')));
      await tester.pump();
      expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '-1');
    },
  );

  testWidgets('Small screen can scroll to controls without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.byKey(const Key('increment')));
    await tester.tap(find.byKey(const Key('increment')));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.widget<Text>(find.byKey(const Key('counter'))).data, '1');
  });
}
