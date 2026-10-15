import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:lab4_recurring_bills/data/bill_repository.dart';
import 'package:lab4_recurring_bills/models/bill.dart';

void main() {
  sqfliteFfiInit();
  late Directory temporary;
  late String location;
  late SqliteBillRepository repository;
  const example = Bill(
    name: 'Electricity',
    category: 'Utilities',
    amount: 850000,
    dueDate: '2026-10-30',
  );
  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('lab4_sqlite_test_');
    location = '${temporary.path}/bills.db';
    repository = await SqliteBillRepository.open(
      factory: databaseFactoryFfi,
      databasePath: location,
    );
  });
  tearDown(() async {
    await repository.close();
    await temporary.delete(recursive: true);
  });

  test('Fresh SQLite database is empty with zero outstanding total', () async {
    expect(await repository.all(), isEmpty);
    final summary = await repository.unpaidSummary();
    expect(summary.bills, isEmpty);
    expect(summary.total, 0);
  });
  test(
    'Insert auto-generates unique IDs and quoted names remain literal',
    () async {
      final first = await repository.add(example);
      final second = await repository.add(
        example.copyWith(name: "Rent'); DROP TABLE bills;--", category: 'Rent'),
      );
      expect(first, greaterThan(0));
      expect(second, greaterThan(first));
      final bills = await repository.all();
      expect(bills.length, 2);
      expect(
        bills.any((bill) => bill.name == "Rent'); DROP TABLE bills;--"),
        isTrue,
      );
    },
  );
  test('Update all fields; Paid bills are excluded from SQL SUM; deletion removes records', () async {
    final first = await repository.add(example);
    final second = await repository.add(
      example.copyWith(name: 'Internet', amount: 250000),
    );
    expect((await repository.unpaidSummary()).total, 1100000);
    await repository.update(
      example.copyWith(
        id: first,
        name: 'Updated electricity',
        category: 'Other',
        amount: 999000,
        dueDate: '2026-11-01',
        status: BillStatus.paid,
      ),
    );
    final paid = (await repository.all()).firstWhere(
      (bill) => bill.id == first,
    );
    expect(paid.name, 'Updated electricity');
    expect(paid.category, 'Other');
    expect(paid.dueDate, '2026-11-01');
    expect(paid.amount, 999000);
    final summary = await repository.unpaidSummary();
    expect(summary.bills.single.id, second);
    expect(summary.total, 250000);
    await repository.delete(second);
    expect((await repository.unpaidSummary()).total, 0);
    expect((await repository.all()).length, 1);
  });
  test('Closing and reopening the database preserves data', () async {
    final id = await repository.add(example);
    await repository.close();
    repository = await SqliteBillRepository.open(
      factory: databaseFactoryFfi,
      databasePath: location,
    );
    final persisted = (await repository.all()).single;
    expect(persisted.id, id);
    expect(persisted.amount, 850000);
    expect(persisted.status, BillStatus.unpaid);
  });
  test(
    'Invalid input and missing update/delete targets fail without data loss',
    () async {
      await repository.add(example);
      await expectLater(
        repository.add(example.copyWith(amount: 0)),
        throwsArgumentError,
      );
      await expectLater(
        repository.update(example.copyWith(id: 99999)),
        throwsStateError,
      );
      await expectLater(repository.delete(99999), throwsStateError);
      expect((await repository.all()).length, 1);
    },
  );
}
