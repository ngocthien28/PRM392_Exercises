# Slot 3 — Function Processor

Nguồn: **Slot3.pdf**, phần EXERCISE, trang 24. Mỗi thư mục là một exercise độc lập.

Dự án thực hành 1 trong phần EXERCISE (tài liệu gọi là Bài tập 2 – Function). Dart console, không có UI; calculateTotal, calculateAverage, callback có tên và anonymous function.

## Chạy và kiểm tra

Mở chính thư mục này trong VS Code/Android Studio. Flutter SDK dùng để kiểm tra: 3.47.3, Dart 3.13.3. Không cần tài khoản hoặc API key.

```sh
dart pub get
dart analyze
dart test
dart run lib/main.dart
```

Kết quả console:
```text
12
Average: 7.0
Value is: 10
Anonymous value: 5
```

## Phạm vi

Chỉ dùng Dart theo đúng exercise; không tạo APK cho bài console.

Các test trong `test/` kiểm tra hành vi của bài; kết quả chạy thực tế nằm trong `verification/` khi đóng gói. Đây là test viết theo yêu cầu đề, không phải bộ test ẩn của giảng viên (PDF không cung cấp bộ test máy).

Trên Windows, nên giải nén vào đường dẫn không dấu (ví dụ `D:\PRM_Submission\slot03_function_processor`) để tránh lỗi Flutter analyzer với đường dẫn Unicode.
