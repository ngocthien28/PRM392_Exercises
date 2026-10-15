import 'dart:async';

class CounterStreamService {
  CounterStreamService({this.interval = const Duration(seconds: 1)});
  final Duration interval;
  final StreamController<int> _controller = StreamController<int>();
  Stream<int> get counterStream => _controller.stream;
  Timer? _timer;
  int _count = 0;
  bool _disposed = false;

  void start() {
    if (_disposed || _timer != null) return;
    _timer = Timer.periodic(interval, (_) => _controller.add(++_count));
  }

  void simulateError() {
    if (!_disposed) _controller.addError(StateError('Lỗi mô phỏng'));
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    unawaited(_controller.close());
  }
}
