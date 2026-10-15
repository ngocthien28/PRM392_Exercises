# Slot 10 — Responsive Dashboard App

Nguồn: **Slot 10_1.pdf**, phần EXERCISE, trang 22. Mỗi thư mục là một exercise độc lập.

Bài tập tổng hợp. MediaQuery điều chỉnh padding/chữ, LayoutBuilder đổi summary từ Column sang Row và grid 2/3/4 cột theo chiều rộng thực nhận. Nội dung cuộn trên màn hình thấp.

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

Trên Windows, nên giải nén vào đường dẫn không dấu (ví dụ `D:\PRM_Submission\slot10_responsive_dashboard`) để tránh lỗi Flutter analyzer với đường dẫn Unicode.
