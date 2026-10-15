import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot09_product_dashboard/main.dart';

void main() {
  testWidgets(
    'Dashboard opens product grid, scrolls to last item and returns',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(Positioned), findsWidgets);
      await tester.tap(find.text('Xem sản phẩm'));
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('Sản phẩm 1'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Sản phẩm 30'), 400);
      expect(find.text('Sản phẩm 30').hitTestable(), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Product Dashboard'), findsOneWidget);
    },
  );

  for (final size in [const Size(320, 480), const Size(800, 600)]) {
    testWidgets('Layout and grid fit $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Xem sản phẩm'));
      await tester.tap(find.text('Xem sản phẩm'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
