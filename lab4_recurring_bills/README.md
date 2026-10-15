# Lab4 — Manage Recurring Bills App

Ứng dụng Flutter quản lý hóa đơn định kỳ, thực hiện đầy đủ yêu cầu trong `DE_BAI.pdf`. Dữ liệu lưu cục bộ bằng **sqflite / SQLite**, không cần tài khoản hay kết nối mạng khi sử dụng.

## Chức năng

- **Home:** banner ảnh PNG đóng gói bằng `Image.asset`, danh sách hóa đơn gồm tên, danh mục, số tiền VND, hạn thanh toán, Paid/Unpaid. FAB mở màn hình thêm. Chạm hóa đơn để sửa.
- **Add:** kiểm tra tên, danh mục, số tiền, ngày ISO và trạng thái. ID tự tăng; trạng thái mặc định Unpaid. Save ghi SQLite, quay lại Home và tự tải danh sách mới; Back không lưu.
- **Update:** điền sẵn tất cả thông tin, cho sửa và đổi Paid/Unpaid. Ba nút Update/Delete/Back nằm cùng một hàng.
- **Delete:** hộp thoại xác nhận; Cancel giữ nguyên dữ liệu. Thông báo thành công sau thêm/sửa/xóa.
- **Unpaid:** tab dưới màn hình, chỉ hiển thị hóa đơn chưa thanh toán và tổng tiền còn nợ ở phía dưới. Tổng được tính bằng truy vấn SQL có điều kiện `status = 'Unpaid'`.
- Có trạng thái rỗng, tải dữ liệu, lỗi đọc/ghi và thử lại. Nút lưu bị khóa khi đang ghi để tránh tạo trùng hóa đơn.

Đề có dùng các thuật ngữ FlatList/Bottom Tab Navigator của React Native, đồng thời yêu cầu Flutter. Bài sử dụng các thành phần Flutter tương ứng: `ListView.builder` và `BottomNavigationBar`, đúng gợi ý trong PDF.

## Cấu trúc

```text
lib/
  main.dart                        Khởi tạo app và mở database
  models/bill.dart                  Model, enum trạng thái, kiểm tra số/ngày
  data/bill_repository.dart         SQLite schema, CRUD, truy vấn tổng tiền
  screens/home_screen.dart          Home + Unpaid và tự làm mới dữ liệu
  screens/bill_form_screen.dart     Form thêm/sửa và xác nhận xóa
  widgets/bill_card.dart            Thẻ hóa đơn, icon, định dạng VND
assets/bills_banner.png             Banner gốc được vẽ cho bài
test/                              Test model, SQLite thật và giao diện
integration_test/                  Test toàn luồng trên Android thật/emulator
verification/                      Kết quả và bằng chứng kiểm tra
```

## Chạy ứng dụng

Môi trường đã sử dụng: Flutter **3.47.3**, Dart **3.13.3**, Android SDK và emulator. Giải nén vào thư mục **không dấu**, ví dụ `D:\PRM_Submission\lab4_recurring_bills`, để tránh lỗi analyzer với đường dẫn Unicode trong Flutter trên máy Windows này.

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

Build APK:

```sh
flutter build apk --debug
```

APK được tạo tại `build/app/outputs/flutter-apk/app-debug.apk`. Android Studio/Flutter sẽ tạo `android/local.properties` phù hợp SDK của máy bạn. ZIP không chứa SDK, cache hoặc thư mục build.

Kiểm thử tích hợp, sau khi mở emulator:

```sh
flutter devices
flutter test integration_test/bills_flow_test.dart -d emulator-5554
```

Thay `emulator-5554` bằng ID thiết bị của bạn. Integration test dùng **file database riêng** `lab4_integration_test.db`; không xóa dữ liệu trong database chính.

## Dữ liệu và kiểm tra đầu vào

Database chính: `recurring_bills.db` trong thư mục database riêng của ứng dụng Android. Database được tạo lần đầu và mở lại ở những lần tiếp theo; không seed dữ liệu mẫu và không xóa bảng khi khởi động.

| Cột | Kiểu SQLite | Quy tắc |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| bill_name | TEXT | Bắt buộc, trim khoảng trắng, tối đa 120 ký tự |
| category | TEXT | Utilities / Subscription / Rent / Finance / Health / Other |
| amount | REAL | Dương, hữu hạn, không quá 1.000.000.000.000 VND |
| status | TEXT | Paid hoặc Unpaid; mặc định Unpaid |
| due_date | TEXT | Ngày thật dạng YYYY-MM-DD, từ năm 1900 đến 2100 |

Số tiền có thể nhập `850000` hoặc `850.000`; số thập phân tối đa 2 chữ số như `12,50` hoặc `12.50`. Không chấp nhận số âm/0/NaN, ký hiệu khoa học hoặc dấu phân cách hỗn hợp. Ngày nhập tay được kiểm tra cả số ngày trong tháng/năm nhuận; cũng có DatePicker.

Dữ liệu chỉ bị xóa khi xác nhận Delete, xóa dữ liệu ứng dụng hoặc gỡ ứng dụng. Bài không tự sinh hóa đơn tháng kế tiếp hoặc gửi thông báo vì đề không yêu cầu hai chức năng này.

## Tài liệu kỹ thuật đã đối chiếu

- [Flutter — Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite).
- [sqflite — openDatabase](https://pub.dev/documentation/sqflite/latest/sqflite/openDatabase.html).
- [sqflite — hướng dẫn kiểm thử SQLite bằng FFI](https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/doc/testing.md).

Xem kết quả thực tế trong `verification/RESULTS.md`. Các test được viết theo đề; PDF không cung cấp bộ test ẩn của giảng viên.
