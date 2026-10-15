import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot02_daily_planner/main.dart';
import 'package:slot02_daily_planner/widgets/task_item.dart';

void main() {
  testWidgets('Starts empty and adds sequential tasks', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Chưa có công việc. Nhấn + để thêm.'), findsOneWidget);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
    }
    expect(find.byType(TaskItem), findsNWidgets(3));
    expect(find.text('Công việc số 1'), findsOneWidget);
    expect(find.text('Công việc số 3'), findsOneWidget);
  });

  testWidgets('Many tasks remain scrollable on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    for (var i = 0; i < 30; i++) {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
    }
    await tester.ensureVisible(find.text('Công việc số 30'));
    expect(find.text('Công việc số 30').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
