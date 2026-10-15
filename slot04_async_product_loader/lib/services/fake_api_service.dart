import '../models/item.dart';

enum LoadScenario { success, error, empty }

class FakeApiService {
  const FakeApiService({this.delay = const Duration(seconds: 2)});
  final Duration delay;

  Future<List<Item>> fetchItems({
    LoadScenario scenario = LoadScenario.success,
  }) async {
    await Future<void>.delayed(delay);
    if (scenario == LoadScenario.error) {
      throw StateError('Không thể tải sản phẩm. Vui lòng thử lại.');
    }
    if (scenario == LoadScenario.empty) return [];
    return const [
      Item(name: 'Táo', price: 10000),
      Item(name: 'Cam', price: 15000),
      Item(name: 'Chuối', price: 8000),
    ];
  }
}
