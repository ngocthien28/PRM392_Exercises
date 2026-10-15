import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot04_async_product_loader/main.dart';
import 'package:slot04_async_product_loader/models/item.dart';
import 'package:slot04_async_product_loader/services/fake_api_service.dart';
import 'package:slot04_async_product_loader/screens/home_screen.dart';

class ControlledService extends FakeApiService {
  int calls = 0;
  final result = Completer<List<Item>>();
  @override
  Future<List<Item>> fetchItems({
    LoadScenario scenario = LoadScenario.success,
  }) {
    calls++;
    return result.future;
  }
}

Future<void> finishLoad(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pump();
}

void main() {
  testWidgets('Loading lasts until the delayed result arrives', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Táo'), findsNothing);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Táo'), findsOneWidget);
    expect(find.text('10000 VND'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('Error can be retried and empty data has a message', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await finishLoad(tester);
    await tester.tap(find.byTooltip('Kịch bản tải'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mô phỏng lỗi'));
    await tester.pump();
    await finishLoad(tester);
    expect(find.text('Có lỗi xảy ra khi tải sản phẩm.'), findsOneWidget);
    await tester.tap(find.text('Thử lại'));
    await tester.pump();
    await finishLoad(tester);
    expect(find.text('Cam'), findsOneWidget);
    await tester.tap(find.byTooltip('Kịch bản tải'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Danh sách rỗng'));
    await tester.pump();
    await finishLoad(tester);
    expect(find.text('Chưa có sản phẩm.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Parent rebuild does not start another request', (tester) async {
    final service = ControlledService();
    await tester.pumpWidget(MaterialApp(home: HomeScreen(service: service)));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: HomeScreen(service: service),
      ),
    );
    expect(service.calls, 1);
    service.result.complete(const [Item(name: 'Kiểm tra', price: 1)]);
    await tester.pumpAndSettle();
    expect(find.text('Kiểm tra'), findsOneWidget);
  });
}
