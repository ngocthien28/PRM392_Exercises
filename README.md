# Slot 8 — Student Manager App

Nguồn: **Slot8.pdf**, phần EXERCISE, trang 19. Mỗi thư mục là một exercise độc lập.

Bài tập tổng hợp 1. Named routes + arguments, danh sách/chi tiết/thêm/sửa, Navigator.push/pop trả Student, Android deep link, xử lý route sai và mã không tồn tại.

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

## Android deep link

Cài APK rồi chạy (thay SV01 bằng mã cần xem):

```sh
adb shell am start -W -a android.intent.action.VIEW -d "studentapp://student/detail?id=SV01" vn.edu.prm.slot08_student_manager
```

Cũng hỗ trợ `studentapp://student/SV01` và route `/student/SV01`. Cold start dựng Home dưới Detail, Back quay về Home. Mã không tồn tại hiển thị thông báo; không ép kiểu arguments khi sai kiểu.

Navigator 1.0: push/pop ra lệnh trực tiếp cho stack. Navigator 2.0: danh sách Page được tạo theo trạng thái; bài này yêu cầu nhận thức khái niệm, không bắt buộc đổi sang Router. StudentStore giữ một nguồn dữ liệu cho List/Detail nên sửa ở Form được cập nhật nhất quán.

Trên Windows, nên giải nén vào đường dẫn không dấu (ví dụ `D:\PRM_Submission\slot08_student_manager`) để tránh lỗi Flutter analyzer với đường dẫn Unicode.
