import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Simple Planner App',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const HomeScreen(),
  );
}
