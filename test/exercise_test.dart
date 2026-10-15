import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot05_live_counter_stream/main.dart';
import 'package:slot05_live_counter_stream/services/counter_stream_service.dart';

void main() {
  testWidgets('Stream emits each second and recovers after a simulated error', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Counter: 1'), findsOneWidget);
    await tester.tap(find.text('Mô phỏng lỗi'));
    await tester.pump();
    expect(
      find.text('Có lỗi xảy ra. Đang chờ dữ liệu tiếp theo.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Counter: 2'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
    expect(tester.takeException(), isNull);
  });

  test(
    'Start is idempotent; dispose closes stream and cancels timer',
    () async {
      final service = CounterStreamService(
        interval: const Duration(milliseconds: 10),
      );
      final values = <int>[];
      final closed = Completer<void>();
      final subscription = service.counterStream.listen((value) {
        values.add(value);
        if (value == 2) service.dispose();
      }, onDone: closed.complete);
      service.start();
      service.start();
      await closed.future.timeout(const Duration(seconds: 2));
      service.dispose();
      service.start();
      service.simulateError();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(values, [1, 2]);
      await subscription.cancel();
    },
  );
}
