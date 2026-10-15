import 'dart:async';

import 'package:flutter/material.dart';

import 'data/bill_repository.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Lab4App());
}

class Lab4App extends StatefulWidget {
  const Lab4App({super.key, this.repository});
  final BillRepository? repository;
  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  late Future<BillRepository> _opening;
  BillRepository? _ownedRepository;
  @override
  void initState() {
    super.initState();
    _opening = widget.repository == null
        ? _openDatabase()
        : Future.value(widget.repository!);
  }

  Future<BillRepository> _openDatabase() async {
    final repository = await SqliteBillRepository.open();
    if (!mounted) {
      await repository.close();
      throw StateError('App closed during initialization.');
    }
    _ownedRepository = repository;
    return repository;
  }

  @override
  void dispose() {
    if (_ownedRepository != null) unawaited(_ownedRepository!.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Recurring Bills Manager',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6d35c5)),
      scaffoldBackgroundColor: const Color(0xfff8f6fc),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: const CardThemeData(
        elevation: 0.5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    ),
    home: FutureBuilder<BillRepository>(
      future: _opening,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Recurring Bills')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Could not open the local database.'),
                  FilledButton(
                    onPressed: () => setState(() => _opening = _openDatabase()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return HomeScreen(repository: snapshot.data!);
      },
    ),
  );
}
