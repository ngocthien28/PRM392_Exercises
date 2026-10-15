import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/bill.dart';

abstract interface class BillRepository {
  Future<List<Bill>> all();
  Future<UnpaidSummary> unpaidSummary();
  Future<int> add(Bill bill);
  Future<void> update(Bill bill);
  Future<void> delete(int id);
  Future<void> close();
}

class SqliteBillRepository implements BillRepository {
  SqliteBillRepository._(this._db);
  final Database _db;

  static Future<SqliteBillRepository> open({
    DatabaseFactory? factory,
    String? databasePath,
  }) async {
    final selectedFactory = factory ?? databaseFactory;
    final location =
        databasePath ??
        path.join(
          await selectedFactory.getDatabasesPath(),
          'recurring_bills.db',
        );
    final db = await selectedFactory.openDatabase(
      location,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE bills (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bill_name TEXT NOT NULL CHECK(length(trim(bill_name)) BETWEEN 1 AND 120),
            category TEXT NOT NULL,
            amount REAL NOT NULL CHECK(amount > 0 AND amount <= 1000000000000),
            status TEXT NOT NULL DEFAULT 'Unpaid' CHECK(status IN ('Paid', 'Unpaid')),
            due_date TEXT NOT NULL
          )
        ''');
          await db.execute(
            'CREATE INDEX idx_bills_status_due ON bills(status, due_date)',
          );
        },
      ),
    );
    return SqliteBillRepository._(db);
  }

  @override
  Future<List<Bill>> all() async => (await _db.query(
    'bills',
    orderBy: 'due_date ASC, id DESC',
  )).map(Bill.fromMap).toList();

  @override
  Future<UnpaidSummary> unpaidSummary() => _db.transaction((txn) async {
    final rows = await txn.query(
      'bills',
      where: 'status = ?',
      whereArgs: ['Unpaid'],
      orderBy: 'due_date ASC, id DESC',
    );
    final sum = await txn.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM bills WHERE status = ?',
      ['Unpaid'],
    );
    return UnpaidSummary(
      bills: rows.map(Bill.fromMap).toList(),
      total: (sum.single['total'] as num).toDouble(),
    );
  });

  @override
  Future<int> add(Bill bill) async {
    bill.validate();
    final values = bill.toMap()..remove('id');
    return _db.insert('bills', values);
  }

  @override
  Future<void> update(Bill bill) async {
    bill.validate();
    if (bill.id == null) {
      throw ArgumentError('An existing bill ID is required.');
    }
    final values = bill.toMap()..remove('id');
    final changed = await _db.update(
      'bills',
      values,
      where: 'id = ?',
      whereArgs: [bill.id],
    );
    if (changed != 1) throw StateError('This bill no longer exists.');
  }

  @override
  Future<void> delete(int id) async {
    final changed = await _db.delete('bills', where: 'id = ?', whereArgs: [id]);
    if (changed != 1) throw StateError('This bill no longer exists.');
  }

  @override
  Future<void> close() => _db.close();
}
