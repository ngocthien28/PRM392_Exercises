import 'package:lab4_recurring_bills/data/bill_repository.dart';
import 'package:lab4_recurring_bills/models/bill.dart';

/// UI tests use a controllable repository; database_test covers real SQLite.
class MemoryRepository implements BillRepository {
  final List<Bill> bills = [];
  bool failSave = false;
  bool failLoad = false;
  int _nextId = 1;
  @override
  Future<List<Bill>> all() async {
    if (failLoad) throw StateError('Load failed');
    return List.of(bills);
  }

  @override
  Future<UnpaidSummary> unpaidSummary() async {
    final unpaid = bills
        .where((bill) => bill.status == BillStatus.unpaid)
        .toList();
    return UnpaidSummary(
      bills: unpaid,
      total: unpaid.fold(0, (sum, bill) => sum + bill.amount),
    );
  }

  @override
  Future<int> add(Bill bill) async {
    if (failSave) throw StateError('Save failed');
    bill.validate();
    final id = _nextId++;
    bills.add(bill.copyWith(id: id));
    return id;
  }

  @override
  Future<void> update(Bill bill) async {
    if (failSave) throw StateError('Save failed');
    bill.validate();
    bills[bills.indexWhere((item) => item.id == bill.id)] = bill;
  }

  @override
  Future<void> delete(int id) async {
    bills.removeWhere((bill) => bill.id == id);
  }

  @override
  Future<void> close() async {}
}
