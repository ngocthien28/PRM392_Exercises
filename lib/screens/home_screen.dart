import 'package:flutter/material.dart';

import '../models/plan.dart';
import '../widgets/primary_button.dart';
import 'create_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Plan> _plans = [];

  Future<void> _createPlan() async {
    final plan = await Navigator.push<Plan>(
      context,
      MaterialPageRoute(builder: (_) => const CreatePlanScreen()),
    );
    if (!mounted || plan == null) return;
    setState(() => _plans.add(plan));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Simple Planner')),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              label: 'Tạo kế hoạch mới',
              onPressed: _createPlan,
            ),
          ),
          Expanded(
            child: _plans.isEmpty
                ? const Center(child: Text('Chưa có kế hoạch.'))
                : ListView.builder(
                    itemCount: _plans.length,
                    itemBuilder: (context, index) {
                      final plan = _plans[index];
                      final localizations = MaterialLocalizations.of(context);
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(plan.title),
                          subtitle: Text(
                            '${localizations.formatMediumDate(plan.scheduledAt)} • ${TimeOfDay.fromDateTime(plan.scheduledAt).format(context)}',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
