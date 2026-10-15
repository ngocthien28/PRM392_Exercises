import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/fake_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.service = const FakeApiService()});
  final FakeApiService service;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Item>> _items;

  @override
  void initState() {
    super.initState();
    // Giữ Future ngoài build: rebuild UI không tạo request mới.
    _items = widget.service.fetchItems();
  }

  void _load(LoadScenario scenario) => setState(() {
    _items = widget.service.fetchItems(scenario: scenario);
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Async Product Loader'),
      actions: [
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () => _load(LoadScenario.success),
          icon: const Icon(Icons.refresh),
        ),
        PopupMenuButton<LoadScenario>(
          tooltip: 'Kịch bản tải',
          onSelected: _load,
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: LoadScenario.error,
              child: Text('Mô phỏng lỗi'),
            ),
            PopupMenuItem(
              value: LoadScenario.empty,
              child: Text('Danh sách rỗng'),
            ),
          ],
        ),
      ],
    ),
    body: FutureBuilder<List<Item>>(
      future: _items,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Có lỗi xảy ra khi tải sản phẩm.'),
                FilledButton(
                  onPressed: () => _load(LoadScenario.success),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        final items = snapshot.data ?? const <Item>[];
        if (items.isEmpty) {
          return const Center(child: Text('Chưa có sản phẩm.'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: const Icon(Icons.shopping_basket_outlined),
              title: Text(item.name),
              subtitle: Text('${item.price.toStringAsFixed(0)} VND'),
            );
          },
        );
      },
    ),
  );
}
