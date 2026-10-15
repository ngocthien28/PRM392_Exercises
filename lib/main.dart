import 'package:flutter/material.dart';

import 'models/student_store.dart';
import 'routes/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialRoute});
  final String? initialRoute;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _store = StudentStore();
  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Student Manager',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    initialRoute: widget.initialRoute,
    onGenerateRoute: (settings) => AppRoutes.generate(settings, _store),
    onGenerateInitialRoutes: (route) => AppRoutes.initial(route, _store),
  );
}
