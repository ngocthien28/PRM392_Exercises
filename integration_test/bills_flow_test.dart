import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:lab4_recurring_bills/data/bill_repository.dart';
import 'package:lab4_recurring_bills/main.dart';
import 'package:lab4_recurring_bills/models/bill.dart';
import 'package:lab4_recurring_bills/widgets/bill_card.dart';

Future<void> tap(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Android SQLite: add, validate, update status, summary, reopen, confirm delete',
    (tester) async {
      // Isolated file: integration tests never erase the user's normal database.
      final location = path.join(
        await getDatabasesPath(),
        'lab4_integration_test.db',
      );
      await deleteDatabase(location);
      var repository = await SqliteBillRepository.open(databasePath: location);
      addTearDown(() async {
        await repository.close();
        await deleteDatabase(location);
      });
      await tester.pumpWidget(Lab4App(repository: repository));
      await tester.pumpAndSettle();
      expect(find.text('No bills yet'), findsOneWidget);
      await tester.tap(find.byTooltip('Add bill'));
      await tester.pumpAndSettle();
      await tap(tester, 'saveBill');
      expect(find.text('Please enter bill name'), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('billName')),
        'Electricity - Integration',
      );
      await tester.enterText(find.byKey(const Key('amount')), '850000');
      await tester.enterText(find.byKey(const Key('dueDate')), '2026-10-30');
      await tap(tester, 'saveBill');
      expect(find.text('Bill added successfully'), findsOneWidget);
      expect((await repository.all()).single.status, BillStatus.unpaid);
      await tester.tap(find.byIcon(Icons.pending_actions_outlined));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('outstandingTotal'))).data,
        formatVnd(850000),
      );
      await tester.tap(find.byType(BillCard));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('billName')),
        'Updated Electricity',
      );
      await tester.enterText(find.byKey(const Key('amount')), '900000');
      await tester.enterText(find.byKey(const Key('dueDate')), '2026-11-02');
      await tap(tester, 'category');
      await tester.tap(find.text('Other').last);
      await tester.pumpAndSettle();
      await tap(tester, 'status');
      await tester.tap(find.text('Paid').last);
      await tester.pumpAndSettle();
      await tap(tester, 'saveBill');
      expect(
        tester.widget<Text>(find.byKey(const Key('outstandingTotal'))).data,
        formatVnd(0),
      );
      final saved = (await repository.all()).single;
      expect(saved.name, 'Updated Electricity');
      expect(saved.category, 'Other');
      expect(saved.amount, 900000);
      expect(saved.dueDate, '2026-11-02');
      expect(saved.status, BillStatus.paid);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await repository.close();
      repository = await SqliteBillRepository.open(databasePath: location);
      await tester.pumpWidget(Lab4App(repository: repository));
      await tester.pumpAndSettle();
      expect(find.text('Updated Electricity'), findsOneWidget);
      await tester.tap(find.byType(BillCard));
      await tester.pumpAndSettle();
      await tap(tester, 'status');
      await tester.tap(find.text('Unpaid').last);
      await tester.pumpAndSettle();
      await tap(tester, 'saveBill');
      expect((await repository.unpaidSummary()).total, 900000);
      await tester.tap(find.byType(BillCard));
      await tester.pumpAndSettle();
      await tap(tester, 'deleteBill');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect((await repository.all()).length, 1);
      await tap(tester, 'deleteBill');
      await tap(tester, 'confirmDelete');
      expect(await repository.all(), isEmpty);
      expect((await repository.unpaidSummary()).total, 0);
      expect(find.text('Bill deleted successfully'), findsOneWidget);
    },
  );
}
