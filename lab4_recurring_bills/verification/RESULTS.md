# Kết quả kiểm tra Lab4

Ngày: **13/10/2026**, Asia/Saigon. Flutter **3.47.3**, Dart **3.13.3**, Android emulator Medium_Phone.

| Hạng mục | Kết quả |
|---|---|
| flutter analyze | PASS — No issues found |
| Test model | 5/5 PASS |
| Test database với SQLite thật (FFI) | 5/5 PASS |
| Test giao diện | 8/8 PASS |
| Integration test Android với sqflite | 1/1 PASS |
| Build APK debug từ lib/main.dart | PASS |
| Cài và chạy bản APK bình thường | PASS |
| Đóng hẳn process rồi mở lại, dữ liệu còn nguyên | PASS |
| Xóa hóa đơn thử sau khi xác nhận | PASS |

## Các trường hợp đã kiểm tra

- Tên rỗng, số tiền âm/0/NaN/quá giới hạn, dấu phân cách sai, ngày không tồn tại, năm nhuận, ngày ISO.
- ID tự tăng; tên có dấu nháy được lưu bằng tham số an toàn; sửa tất cả trường; trạng thái Paid bị loại khỏi tổng Unpaid; xóa đúng bản ghi.
- Database đóng/mở lại giữ dữ liệu. Update/delete ID không tồn tại báo lỗi mà không làm mất bản ghi khác.
- Banner, danh sách rỗng, thêm hóa đơn mặc định Unpaid, đổi danh mục/ngày/số tiền/trạng thái, tổng tiền 7.350.000 VND cho 2 hóa đơn Unpaid trong dữ liệu mẫu test.
- Hủy xóa giữ dữ liệu; xác nhận mới xóa; Back không ghi. Ba nút Update/Delete/Back cùng hàng ở màn hình 320×568.
- Lỗi tải/ghi có phản hồi và thử lại; thông báo thành công mới thay thông báo cũ ngay.
- Integration Android thao tác form thật, ghi/đọc SQLite bằng sqflite, kiểm tra lại sau mở database và xác nhận xóa.
- Bản APK bình thường: thêm hóa đơn 850.000 VND, force-stop tiến trình Android, khởi động lại, xác nhận hóa đơn và tổng Unpaid vẫn là 850.000 VND, rồi xóa hóa đơn thử qua hộp thoại xác nhận.

## Bằng chứng

- analyze.log, test.log, integration.log, build.log.
- android-persistence.log, android-errors.log và cây giao diện XML.
- Ảnh: android-home-empty.png, android-home-added.png, android-unpaid.png, android-update.png, android-delete-confirmation.png.

APK chính đã kiểm tra: build/app/outputs/flutter-apk/app-debug.apk (không kèm trong ZIP source).
SHA-256: 2df838b67ef01e6407d006fd88565f3647c0233df976c984995e6018d1899c04.

Integration test dùng database riêng, không đụng database người dùng. Hóa đơn tạo bởi bài kiểm tra force-stop đã được xóa bằng UI sau kiểm tra. Không ghi nhận lỗi runtime Android/Flutter trong bước kiểm tra bản APK bình thường.

Đây là bộ test viết theo đề Lab4; không có test ẩn của giảng viên được cung cấp. Android là nền tảng đã build/chạy, không xác nhận iOS/Web.
