import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slot10_responsive_dashboard/main.dart';
import 'package:slot10_responsive_dashboard/widgets/responsive_grid.dart';
import 'package:slot10_responsive_dashboard/screens/dashboard_screen.dart';

void main() {
  test('Grid breakpoints use available width', () {
    expect(ResponsiveProductGrid.columnsFor(599), 2);
    expect(ResponsiveProductGrid.columnsFor(600), 3);
    expect(ResponsiveProductGrid.columnsFor(899), 3);
    expect(ResponsiveProductGrid.columnsFor(900), 4);
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(800, 1024),
    const Size(1200, 800),
    const Size(844, 390),
  ]) {
    testWidgets('Responsive layout fits $size and reaches final item', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      expect(tester.takeException(), isNull);
      final padding = (size.width * .04).clamp(12.0, 40.0);
      final available = size.width - padding * 2;
      expect(
        find.byKey(Key(available < 600 ? 'summaryColumn' : 'summaryRow')),
        findsOneWidget,
      );
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(
        delegate.crossAxisCount,
        ResponsiveProductGrid.columnsFor(available),
      );
      await tester.ensureVisible(find.text('Sản phẩm 12'));
      expect(find.text('Sản phẩm 12').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Large accessibility text does not overflow a small phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const DashboardScreen(),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Sản phẩm 12'));
    expect(tester.takeException(), isNull);
  });
}
