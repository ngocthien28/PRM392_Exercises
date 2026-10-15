# Slot 9 — Simple Product Dashboard App

Nguồn: **Slot 9.pdf**, phần EXERCISE, trang 21. Mỗi thư mục là một exercise độc lập.

Bài tập tổng hợp 1. Dashboard dùng Row/Column/Expanded, Stack + Positioned tạo badge; Navigator.push mở GridView.builder với 30 sản phẩm có cuộn. iOS URL Scheme chỉ cần giải thích theo đề, xem bên dưới.

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

## iOS URL Scheme (phần giải thích theo đề)

`myapp://products` là link hệ điều hành có thể chuyển cho app. Trên iOS cần đăng ký `myapp` trong CFBundleURLTypes của Info.plist, nhận URI và ánh xạ host `products` sang màn hình ProductGridScreen. Khác với Navigator.push phát sinh từ nút bấm, đây là điểm vào từ ngoài ứng dụng. Theo đề trang 22, phần iOS chỉ cần giải thích; project này không triển khai/công bố đã kiểm thử iOS deep link.

Trên Windows, nên giải nén vào đường dẫn không dấu (ví dụ `D:\PRM_Submission\slot09_product_dashboard`) để tránh lỗi Flutter analyzer với đường dẫn Unicode.
