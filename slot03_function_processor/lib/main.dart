/// Các hàm xử lý chỉ trả kết quả; phần hiển thị được tách riêng.
int calculateTotal(int a, int b) => a + b;

double calculateAverage(int a, int b) => (a + b) / 2;

void processNumber(int number, void Function(int) callback) {
  callback(number);
}

void process(int number, void Function(int) callback) {
  callback(number);
}

void printNumber(int value) => print('Value is: $value');

void main() {
  print(calculateTotal(5, 7));
  print('Average: ${calculateAverage(6, 8)}');
  processNumber(10, printNumber);
  process(5, (value) => print('Anonymous value: $value'));
}
