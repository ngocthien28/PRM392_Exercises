enum BillStatus {
  paid('Paid'),
  unpaid('Unpaid');

  const BillStatus(this.label);
  final String label;
  static BillStatus parse(String value) =>
      BillStatus.values.firstWhere((status) => status.label == value);
}

const billCategories = [
  'Utilities',
  'Subscription',
  'Rent',
  'Finance',
  'Health',
  'Other',
];

class Bill {
  const Bill({
    this.id,
    required this.name,
    required this.category,
    required this.amount,
    this.status = BillStatus.unpaid,
    required this.dueDate,
  });
  final int? id;
  final String name;
  final String category;
  final double amount;
  final BillStatus status;
  final String dueDate;

  void validate() {
    if (name.trim().isEmpty || name.trim().length > 120) {
      throw ArgumentError('Bill name must contain 1–120 characters.');
    }
    if (!billCategories.contains(category)) {
      throw ArgumentError('Choose a valid category.');
    }
    if (!amount.isFinite || amount <= 0 || amount > 1000000000000) {
      throw ArgumentError(
        'Amount must be greater than 0 and at most 1,000,000,000,000 VND.',
      );
    }
    if (parseIsoDate(dueDate) == null) {
      throw ArgumentError('Enter a valid date in YYYY-MM-DD format.');
    }
  }

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'bill_name': name.trim(),
    'category': category,
    'amount': amount,
    'status': status.label,
    'due_date': dueDate,
  };

  factory Bill.fromMap(Map<String, Object?> row) => Bill(
    id: row['id'] as int,
    name: row['bill_name'] as String,
    category: row['category'] as String,
    amount: (row['amount'] as num).toDouble(),
    status: BillStatus.parse(row['status'] as String),
    dueDate: row['due_date'] as String,
  );

  Bill copyWith({
    int? id,
    String? name,
    String? category,
    double? amount,
    BillStatus? status,
    String? dueDate,
  }) => Bill(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    dueDate: dueDate ?? this.dueDate,
  );
}

String isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

DateTime? parseIsoDate(String value) {
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return null;
  final date = DateTime.tryParse(value);
  if (date == null ||
      date.year < 1900 ||
      date.year > 2100 ||
      isoDate(date) != value) {
    return null;
  }
  return date;
}

/// Plain numbers, Vietnamese thousands (850.000) or up to 2 decimal digits.
double? parseAmount(String input) {
  var value = input.trim();
  if (RegExp(r'^\d{1,3}([.,])\d{3}(?:\1\d{3})*$').hasMatch(value)) {
    value = value.replaceAll(RegExp(r'[.,]'), '');
  } else {
    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(value)) return null;
    value = value.replaceAll(',', '.');
  }
  final amount = double.tryParse(value);
  if (amount == null ||
      !amount.isFinite ||
      amount <= 0 ||
      amount > 1000000000000) {
    return null;
  }
  return amount;
}

class UnpaidSummary {
  const UnpaidSummary({required this.bills, required this.total});
  final List<Bill> bills;
  final double total;
}
