import 'package:flutter/material.dart';

import '../data/bill_repository.dart';
import '../models/bill.dart';

class BillFormScreen extends StatefulWidget {
  const BillFormScreen({super.key, required this.repository, this.bill});
  final BillRepository repository;
  final Bill? bill;
  @override
  State<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends State<BillFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _date;
  late String _category;
  late BillStatus _status;
  bool _busy = false;
  String? _error;
  bool get _editing => widget.bill != null;

  @override
  void initState() {
    super.initState();
    final bill = widget.bill;
    _name = TextEditingController(text: bill?.name);
    _amount = TextEditingController(
      text: bill == null
          ? ''
          : bill.amount.toStringAsFixed(
              bill.amount == bill.amount.roundToDouble() ? 0 : 2,
            ),
    );
    _date = TextEditingController(text: bill?.dueDate);
    _category = bill?.category ?? billCategories.first;
    _status = bill?.status ?? BillStatus.unpaid;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: parseIsoDate(_date.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
    );
    if (!mounted || selected == null) return;
    setState(() => _date.text = isoDate(selected));
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final bill = Bill(
      id: widget.bill?.id,
      name: _name.text.trim(),
      category: _category,
      amount: parseAmount(_amount.text)!,
      status: _status,
      dueDate: _date.text.trim(),
    );
    try {
      if (_editing) {
        await widget.repository.update(bill);
      } else {
        await widget.repository.add(bill);
      }
      if (mounted) {
        Navigator.pop(
          context,
          _editing ? 'Bill updated successfully' : 'Bill added successfully',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not save this bill. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Permanently delete "${widget.bill!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirmDelete'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.delete(widget.bill!.id!);
      if (mounted) Navigator.pop(context, 'Bill deleted successfully');
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Could not delete this bill. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Update Bill' : 'Add New Bill')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AbsorbPointer(
            absorbing: _busy,
            child: Form(
              key: _form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const Key('billName'),
                    controller: _name,
                    maxLength: 120,
                    decoration: const InputDecoration(
                      labelText: 'Bill Name *',
                      hintText: 'Electricity - October',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter bill name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: const Key('category'),
                    initialValue: _category,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Category *'),
                    items: billCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _category = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('amount'),
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Amount (VND) *',
                      hintText: '850000',
                      helperText: 'Example: 850000 or 850.000',
                    ),
                    validator: (value) => parseAmount(value ?? '') == null
                        ? 'Enter a positive amount (maximum 1 trillion VND)'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('dueDate'),
                    controller: _date,
                    decoration: InputDecoration(
                      labelText: 'Due Date *',
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: IconButton(
                        tooltip: 'Choose date',
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    validator: (value) =>
                        parseIsoDate(value?.trim() ?? '') == null
                        ? 'Enter a valid date: YYYY-MM-DD'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<BillStatus>(
                    key: const Key('status'),
                    initialValue: _status,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Status *'),
                    items: BillStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _status = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _error!,
                        key: const Key('formError'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if (_busy)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: LinearProgressIndicator(),
                    ),
                  // All three update actions stay on the same row, as required.
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          key: const Key('saveBill'),
                          onPressed: _busy ? null : _save,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(_editing ? 'Update' : 'Save'),
                          ),
                        ),
                      ),
                      if (_editing) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            key: const Key('deleteBill'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .error,
                            ),
                            onPressed: _busy ? null : _delete,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Delete'),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('backForm'),
                          onPressed: _busy
                              ? null
                              : () => Navigator.pop(context),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Back'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
