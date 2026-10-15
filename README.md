# Slot 4 — Async Product Loader

Nguồn: **Slot4.pdf**, phần EXERCISE, trang 34. Mỗi thư mục là một exercise độc lập.

Bài tập tổng hợp 1. Fake API chờ 2 giây, FutureBuilder hiển thị loading/data/error/empty. Nút tải lại và menu mô phỏng lỗi/rỗng. Future được tạo trong initState hoặc khi người dùng tải lại.

## Chạy và kiểm tra

Mở chính thư mục này trong VS Code/Android Studio. Flutter SDK dùng để kiểm tra: 3.47.3, Dart 3.13.3. Không cần tài khoản hoặc API key.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Build APK: `flutter build apk --debug`. Chạy trình duyệt khi cần: `flutter run -d chrome`. Thư mục android và web đã có đầy đủ cấu hình. `android/local.properties` sẽ được Flutter tạo lại theo máy của bạn.

## Phạm vi

Dữ liệu mẫu lưu trong bộ nhớ và được đặt lại khi khởi động lại app, theo phạm vi bài tập; không có database/backend.

Các test trong `test/` kiểm tra hành vi của bài; kết quả chạy thực tế nằm trong `verification/` khi đóng gói. Đây là test viết theo yêu cầu đề, không phải bộ test ẩn của giảng viên (PDF không cung cấp bộ test máy).

Trên Windows, nên giải nén vào đường dẫn không dấu (ví dụ `D:\PRM_Submission\slot04_async_product_loader`) để tránh lỗi Flutter analyzer với đường dẫn Unicode.
