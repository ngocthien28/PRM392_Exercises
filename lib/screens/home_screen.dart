import 'package:flutter/material.dart';

import '../services/counter_stream_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CounterStreamService _service;

  @override
  void initState() {
    super.initState();
    _service = CounterStreamService()..start();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Live Counter Stream')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<int>(
              stream: _service.counterStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                    'Có lỗi xảy ra. Đang chờ dữ liệu tiếp theo.',
                  );
                }
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Text(
                  'Counter: ${snapshot.data}',
                  style: Theme.of(context).textTheme.headlineLarge,
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Dữ liệu được cập nhật mỗi giây.'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _service.simulateError,
              child: const Text('Mô phỏng lỗi'),
            ),
          ],
        ),
      ),
    ),
  );
}
