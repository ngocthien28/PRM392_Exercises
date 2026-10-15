import 'dart:async';
import 'package:test/test.dart';
import 'package:slot03_function_processor/main.dart' as app;

void main() {
  test('Sum handles positive, zero, and negative inputs', () {
    expect(app.calculateTotal(5, 7), 12);
    expect(app.calculateTotal(0, 0), 0);
    expect(app.calculateTotal(-8, 3), -5);
  });
  test('Average retains fractional output', () {
    expect(app.calculateAverage(6, 8), 7.0);
    expect(app.calculateAverage(1, 2), 1.5);
    expect(app.calculateAverage(-4, -1), -2.5);
  });
  test('Named callback receives input exactly once', () {
    final values = <int>[];
    app.processNumber(10, values.add);
    expect(values, [10]);
  });
  test('Anonymous callback receives zero and negative values', () {
    final values = <int>[];
    app.process(0, (value) => values.add(value));
    app.process(-5, (value) => values.add(value));
    expect(values, [0, -5]);
  });
  test('Console example matches the exercise output', () {
    final lines = <String>[];
    runZoned(
      app.main,
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) => lines.add(line),
      ),
    );
    expect(lines, ['12', 'Average: 7.0', 'Value is: 10', 'Anonymous value: 5']);
  });
}
