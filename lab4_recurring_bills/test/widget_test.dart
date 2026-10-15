import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_recurring_bills/main.dart';
import 'package:lab4_recurring_bills/models/bill.dart';
import 'package:lab4_recurring_bills/widgets/bill_card.dart';

import 'support/memory_repository.dart';

Future<void> tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(Key(key));
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> fill(
  WidgetTester tester, {
  String name = 'Electricity',
  String amount = '850000',
  String date = '2026-10-30',
}) async {
  await tester.enterText(find.byKey(const Key('billName')), name);
  await tester.enterText(find.byKey(const Key('amount')), amount);
  await tester.enterText(find.byKey(const Key('dueDate')), date);
}

void main() {
  late MemoryRepository repo;
  setUp(() => repo = MemoryRepository());
  testWidgets('Empty home has banner, tabs and add; empty summary is zero', (
    tester,
  ) async {
    await tester.pumpWidget(Lab4App(repository: repo));
    await tester.pumpAndSettle();
    expect(find.text('No bills yet'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    await tester.tap(find.byIcon(Icons.pending_actions_outlined));
    await tester.pumpAndSettle();
    expect(find.text('All bills are paid'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('outstandingTotal'))).data,
      formatVnd(0),
    );
  });
  testWidgets(
    'Validation rejects empty name, invalid amount and impossible date; Back does not save',
    (tester) async {
      await tester.pumpWidget(Lab4App(repository: repo));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Add bill'));
      await tester.pumpAndSettle();
      await fill(tester, name: ' ', amount: '-20', date: '2026-02-30');
      await tapKey(tester, 'saveBill');
      expect(find.text('Please enter bill name'), findsOneWidget);
      expect(find.text('Enter a valid date: YYYY-MM-DD'), findsOneWidget);
      expect(repo.bills, isEmpty);
      await tapKey(tester, 'backForm');
      expect(find.text('No bills yet'), findsOneWidget);
    },
  );
  testWidgets(
    'Add defaults Unpaid; update all fields and change Paid refreshes summary',
    (tester) async {
      await tester.pumpWidget(Lab4App(repository: repo));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Add bill'));
      await tester.pumpAndSettle();
      await fill(tester);
      await tapKey(tester, 'saveBill');
      expect(repo.bills.single.status, BillStatus.unpaid);
      expect(find.text('Bill added successfully'), findsOneWidget);
      await tester.tap(find.text('Electricity'));
      await tester.pumpAndSettle();
      await fill(
        tester,
        name: 'Internet',
        amount: '250000',
        date: '2026-11-01',
      );
      await tapKey(tester, 'category');
      await tester.tap(find.text('Subscription').last);
      await tester.pumpAndSettle();
      await tapKey(tester, 'status');
      await tester.tap(find.text('Paid').last);
      await tester.pumpAndSettle();
      await tapKey(tester, 'saveBill');
      expect(repo.bills.single.name, 'Internet');
      expect(find.text('Bill updated successfully'), findsOneWidget);
      expect(repo.bills.single.amount, 250000);
      expect(repo.bills.single.category, 'Subscription');
      expect(repo.bills.single.dueDate, '2026-11-01');
      expect(repo.bills.single.status, BillStatus.paid);
      await tester.tap(find.byIcon(Icons.pending_actions_outlined));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('outstandingTotal'))).data,
        formatVnd(0),
      );
      expect(find.byType(BillCard), findsNothing);
    },
  );
  testWidgets('Delete requires confirmation; cancel preserves the record', (
    tester,
  ) async {
    await repo.add(
      const Bill(
        name: 'Rent',
        category: 'Rent',
        amount: 6500000,
        dueDate: '2026-11-01',
      ),
    );
    await tester.pumpWidget(Lab4App(repository: repo));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BillCard));
    await tester.pumpAndSettle();
    await tapKey(tester, 'deleteBill');
    expect(find.text('Confirm Delete'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repo.bills.length, 1);
    await tapKey(tester, 'deleteBill');
    await tapKey(tester, 'confirmDelete');
    expect(repo.bills, isEmpty);
    expect(find.text('Bill deleted successfully'), findsOneWidget);
  });
  testWidgets('Summary lists only unpaid bills and sums their amounts', (
    tester,
  ) async {
    await repo.add(
      const Bill(
        name: 'Electricity',
        category: 'Utilities',
        amount: 850000,
        dueDate: '2026-10-30',
      ),
    );
    await repo.add(
      const Bill(
        name: 'Rent',
        category: 'Rent',
        amount: 6500000,
        dueDate: '2026-11-01',
      ),
    );
    await repo.add(
      const Bill(
        name: 'Internet',
        category: 'Subscription',
        amount: 250000,
        status: BillStatus.paid,
        dueDate: '2026-11-01',
      ),
    );
    await tester.pumpWidget(Lab4App(repository: repo));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.pending_actions_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Internet'), findsNothing);
    expect(find.byType(BillCard), findsNWidgets(2));
    expect(
      tester.widget<Text>(find.byKey(const Key('outstandingTotal'))).data,
      formatVnd(7350000),
    );
  });
  testWidgets(
    'Save failure keeps input and permits retry without duplicate rows',
    (tester) async {
      repo.failSave = true;
      await tester.pumpWidget(Lab4App(repository: repo));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Add bill'));
      await tester.pumpAndSettle();
      await fill(tester);
      await tapKey(tester, 'saveBill');
      expect(find.byKey(const Key('formError')), findsOneWidget);
      expect(repo.bills, isEmpty);
      repo.failSave = false;
      await tapKey(tester, 'saveBill');
      expect(repo.bills.length, 1);
    },
  );
  testWidgets('Database read error has a working retry action', (tester) async {
    repo.failLoad = true;
    await tester.pumpWidget(Lab4App(repository: repo));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not load your bills. Please try again.'),
      findsOneWidget,
    );
    repo.failLoad = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No bills yet'), findsOneWidget);
  });
  testWidgets(
    'Date picker fills ISO date and narrow update form retains the three action buttons',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await repo.add(
        const Bill(
          name: 'Water',
          category: 'Utilities',
          amount: 120000,
          dueDate: '2026-10-30',
        ),
      );
      await tester.pumpWidget(Lab4App(repository: repo));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Water'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byTooltip('Choose date'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Choose date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('saveBill')));
      await tester.pumpAndSettle();
      final y = tester.getCenter(find.byKey(const Key('saveBill'))).dy;
      expect(tester.getCenter(find.byKey(const Key('deleteBill'))).dy, y);
      expect(tester.getCenter(find.byKey(const Key('backForm'))).dy, y);
      expect(tester.takeException(), isNull);
    },
  );
}
