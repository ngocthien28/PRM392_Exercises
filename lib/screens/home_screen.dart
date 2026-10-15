import 'package:flutter/material.dart';

import '../data/bill_repository.dart';
import '../models/bill.dart';
import '../widgets/bill_card.dart';
import 'bill_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});
  final BillRepository repository;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bill> _bills = [];
  UnpaidSummary _summary = const UnpaidSummary(bills: [], total: 0);
  bool _loading = true;
  String? _error;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final bills = await widget.repository.all();
      final summary = await widget.repository.unpaidSummary();
      if (!mounted) return;
      setState(() {
        _bills = bills;
        _summary = summary;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not load your bills. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm([Bill? bill]) async {
    final message = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BillFormScreen(repository: widget.repository, bill: bill),
      ),
    );
    if (!mounted || message == null) return;
    await _refresh();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _list(List<Bill> bills, {required bool unpaid}) {
    if (bills.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                unpaid ? Icons.task_alt : Icons.receipt_long_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                unpaid ? 'All bills are paid' : 'No bills yet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                unpaid
                    ? 'No outstanding payments.'
                    : 'Press + to add your recurring bills.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        key: ValueKey(unpaid ? 'unpaidList' : 'allBills'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(12, 12, 12, unpaid ? 12 : 88),
        itemCount: bills.length,
        itemBuilder: (_, index) => BillCard(
          key: ValueKey('bill-${bills[index].id}'),
          bill: bills[index],
          onTap: () => _openForm(bills[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_tab == 0 ? 'Recurring Bills' : 'Unpaid Bills')),
    body: SafeArea(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : _tab == 0
          ? Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height < 500 ? 90 : 140,
                  child: Image.asset(
                    'assets/bills_banner.png',
                    fit: BoxFit.cover,
                    semanticLabel: 'Recurring Bills Manager banner',
                  ),
                ),
                Expanded(child: _list(_bills, unpaid: false)),
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Text(
                    '${_summary.bills.length} unpaid bills',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(child: _list(_summary.bills, unpaid: true)),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Outstanding Summary',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Text(
                          'Number of unpaid bills: ${_summary.bills.length}',
                        ),
                        const SizedBox(height: 8),
                        const Text('Total outstanding'),
                        Text(
                          formatVnd(_summary.total),
                          key: const Key('outstandingTotal'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    ),
    floatingActionButton: _tab == 0
        ? FloatingActionButton(
            tooltip: 'Add bill',
            onPressed: _loading ? null : () => _openForm(),
            child: const Icon(Icons.add),
          )
        : null,
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _tab,
      onTap: (index) => setState(() => _tab = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pending_actions_outlined),
          label: 'Unpaid',
        ),
      ],
    ),
  );
}
