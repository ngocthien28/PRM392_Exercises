import 'package:flutter_test/flutter_test.dart';
import 'package:lab4_recurring_bills/models/bill.dart';

void main() {
  test('Amounts support plain, grouped and decimal input', () {
    expect(parseAmount('850000'), 850000);
    expect(parseAmount('850.000'), 850000);
    expect(parseAmount('1,250,000'), 1250000);
    expect(parseAmount(' 12,50 '), 12.5);
    expect(parseAmount('12.50'), 12.5);
  });
  test(
    'Invalid, ambiguous, zero, negative and excessive amounts are rejected',
    () {
      for (final input in [
        '',
        '0',
        '-5',
        'NaN',
        'Infinity',
        '1e5',
        '1.234,567',
        '12.3456',
        '1000000000001',
      ]) {
        expect(parseAmount(input), isNull, reason: input);
      }
    },
  );
  test('Dates require real ISO calendar dates, including leap years', () {
    expect(parseIsoDate('2024-02-29'), DateTime(2024, 2, 29));
    for (final date in [
      '2025-02-29',
      '2026-02-30',
      '2026-13-01',
      '2026-1-01',
      '01/01/2026',
      '',
    ]) {
      expect(parseIsoDate(date), isNull, reason: date);
    }
  });
  test('Model defaults Unpaid, round trips schema, trims name', () {
    const bill = Bill(
      id: 3,
      name: ' Electricity ',
      category: 'Utilities',
      amount: 850000,
      dueDate: '2026-10-30',
    );
    bill.validate();
    final restored = Bill.fromMap(bill.toMap());
    expect(restored.name, 'Electricity');
    expect(restored.id, 3);
    expect(restored.status, BillStatus.unpaid);
    expect(restored.copyWith(status: BillStatus.paid).status, BillStatus.paid);
  });
  test('Repository model validation rejects invalid values', () {
    const bill = Bill(
      name: 'Valid',
      category: 'Utilities',
      amount: 10,
      dueDate: '2026-10-30',
    );
    for (final invalid in [
      bill.copyWith(name: ' '),
      bill.copyWith(amount: double.nan),
      bill.copyWith(amount: -1),
      bill.copyWith(category: 'Invalid'),
      bill.copyWith(dueDate: '2026-02-30'),
    ]) {
      expect(invalid.validate, throwsArgumentError);
    }
  });
}
