import 'package:flutter/material.dart';

import '../models/student.dart';
import '../models/student_store.dart';
import '../screens/home_screen.dart';
import '../screens/student_list_screen.dart';
import '../screens/student_detail_screen.dart';

class AppRoutes {
  static const home = '/';
  static const students = '/students';
  static const detail = '/detail';

  // Accept both Flutter path routes and Android custom-scheme intents.
  static String? studentIdFromLink(String route) {
    final uri = Uri.tryParse(route);
    if (uri == null) return null;
    final segments = uri.pathSegments;
    final queryId = uri.queryParameters['id'];
    final trustedScheme =
        uri.scheme.isEmpty ||
        (uri.scheme == 'studentapp' && uri.host == 'student');
    if (trustedScheme &&
        queryId != null &&
        queryId.isNotEmpty &&
        (uri.path == '/detail' || uri.path == '/student/detail')) {
      return queryId;
    }
    if (uri.scheme.isEmpty &&
        segments.length == 2 &&
        segments.first == 'student') {
      return segments.last;
    }
    if (uri.scheme == 'studentapp' &&
        uri.host == 'student' &&
        segments.length == 1) {
      return segments.single;
    }
    return null;
  }

  static Route<dynamic> generate(RouteSettings settings, StudentStore store) {
    final name = settings.name ?? home;
    Widget screen;
    if (name == home) {
      screen = const HomeScreen();
    } else if (name == students) {
      screen = StudentListScreen(store: store);
    } else if (name == detail && settings.arguments is Student) {
      screen = StudentDetailScreen(
        id: (settings.arguments! as Student).id,
        store: store,
      );
    } else {
      var id = studentIdFromLink(name);
      // WidgetsApp strips scheme/host from warm platform links before
      // calling pushNamed: studentapp://student/SV02 becomes /SV02.
      // Only resolve a short path if it identifies an existing student.
      final uri = Uri.tryParse(name);
      if (id == null &&
          uri != null &&
          uri.scheme.isEmpty &&
          uri.pathSegments.length == 1 &&
          name != detail) {
        final candidate = uri.pathSegments.single;
        if (store.find(candidate) != null) id = candidate;
      }
      screen = id == null
          ? Scaffold(
              appBar: AppBar(title: const Text('Không tìm thấy trang')),
              body: const Center(
                child: Text('Đường dẫn hoặc dữ liệu điều hướng không hợp lệ.'),
              ),
            )
          : StudentDetailScreen(id: id, store: store);
    }
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => screen,
    );
  }

  static List<Route<dynamic>> initial(String route, StudentStore store) => [
    generate(const RouteSettings(name: home), store),
    if (route != home) generate(RouteSettings(name: route), store),
  ];
}
