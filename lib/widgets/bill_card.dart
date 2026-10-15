import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/bill.dart';

String formatVnd(double amount) => NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: amount == amount.roundToDouble() ? 0 : 2,
).format(amount);

IconData categoryIcon(String category) => switch (category) {
  'Utilities' => Icons.bolt_outlined,
  'Subscription' => Icons.wifi,
  'Rent' => Icons.home_outlined,
  'Finance' => Icons.account_balance_outlined,
  'Health' => Icons.health_and_safety_outlined,
  _ => Icons.receipt_long_outlined,
};

class BillCard extends StatelessWidget {
  const BillCard({super.key, required this.bill, required this.onTap});
  final Bill bill;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final paid = bill.status == BillStatus.paid;
    final color = paid ? const Color(0xff176b41) : const Color(0xff985900);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    child: Icon(categoryIcon(bill.category)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          bill.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                formatVnd(bill.amount),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text('Due: ${bill.dueDate}'),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      child: Text(
                        bill.status.label,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
