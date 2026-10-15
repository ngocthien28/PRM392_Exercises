import 'package:flutter/material.dart';

import '../models/plan.dart';
import '../widgets/primary_button.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});
  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  String? _selectionError;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (!mounted || date == null) return;
    setState(() {
      _date = date;
      _selectionError = null;
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (!mounted || time == null) return;
    setState(() {
      _time = time;
      _selectionError = null;
    });
  }

  void _save() {
    final valid = _formKey.currentState!.validate();
    if (_date == null || _time == null) {
      setState(() => _selectionError = 'Vui lòng chọn ngày và giờ.');
      return;
    }
    if (!valid) return;
    Navigator.pop(
      context,
      Plan(
        title: _title.text.trim(),
        scheduledAt: DateTime(
          _date!.year,
          _date!.month,
          _date!.day,
          _time!.hour,
          _time!.minute,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tạo kế hoạch')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const Key('planTitle'),
              controller: _title,
              decoration: const InputDecoration(labelText: 'Tiêu đề kế hoạch'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập tiêu đề.'
                  : null,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              key: const Key('pickDate'),
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                _date == null
                    ? 'Chọn ngày'
                    : MaterialLocalizations.of(context)
                          .formatMediumDate(_date!),
              ),
            ),
            OutlinedButton.icon(
              key: const Key('pickTime'),
              onPressed: _pickTime,
              icon: const Icon(Icons.schedule),
              label: Text(_time == null ? 'Chọn giờ' : _time!.format(context)),
            ),
            if (_selectionError != null)
              Text(
                _selectionError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 16),
            PrimaryButton(label: 'Lưu kế hoạch', onPressed: _save),
          ],
        ),
      ),
    ),
  );
}
