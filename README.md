# PRM392 - Flutter Exercises & Assignments

Repo tổng hợp 10 bài tập thực hành PRM392 (Flutter & Dart). Mỗi bài tập được tổ chức độc lập trên một nhánh (branch) riêng biệt với mã nguồn đặt ngay tại thư mục gốc để thuận tiện cho việc kiểm tra và chạy ứng dụng (`flutter run`).

---

## 📌 Danh sách các bài tập & Nhánh (Branches)

| Slot | Tên bài tập | Nhánh (Branch) | Mô tả tóm tắt |
| :---: | :--- | :---: | :--- |
| **01** | **MyFirstFlutterApp — Personal Info & Counter** | [`slot01`](../../tree/slot01) | Thông tin cá nhân, avatar và bộ đếm tăng/giảm bằng `setState`. |
| **02** | **My Daily Planner** | [`slot02`](../../tree/slot02) | Ứng dụng lập kế hoạch công việc hàng ngày với danh sách task. |
| **03** | **Function Processor** | [`slot03`](../../tree/slot03) | Xử lý logic hàm và kiểm thử tính toán trên Dart. |
| **04** | **Async Product Loader** | [`slot04`](../../tree/slot04) | Tải dữ liệu sản phẩm bất đồng bộ (FutureBuilder, async/await). |
| **05** | **Live Counter Stream** | [`slot05`](../../tree/slot05) | Đếm trực tiếp theo thời gian thực sử dụng Stream/StreamBuilder. |
| **06** | **Student List Interaction App** | [`slot06`](../../tree/slot06) | Quản lý danh sách sinh viên, tương tác xem/chọn item. |
| **07** | **Simple Planner App** | [`slot07`](../../tree/slot07) | Ứng dụng quản lý kế hoạch đơn giản, cập nhật trạng thái công việc. |
| **08** | **Student Manager App** | [`slot08`](../../tree/slot08) | Quản trị sinh viên với đầy đủ thao tác thêm, sửa, xóa, tìm kiếm. |
| **09** | **Simple Product Dashboard App** | [`slot09`](../../tree/slot09) | Dashboard thống kê và hiển thị danh mục sản phẩm. |
| **10** | **Responsive Dashboard App** | [`slot10`](../../tree/slot10) | Dashboard đa màn hình, tương thích Responsive Layout (Mobile/Tablet/Web). |

---

## 🚀 Hướng dẫn kiểm tra và chạy từng bài

Mỗi nhánh (branch) chứa toàn bộ mã nguồn của bài đó ngay tại thư mục gốc.

### 1. Chuyển sang nhánh bài cần kiểm tra
```bash
git checkout slot01   # Hoặc slot02, slot03, ..., slot10
```

### 2. Cài đặt dependencies và chạy
```bash
flutter pub get
flutter run
```

### 3. Kiểm tra mã nguồn & Chạy test
```bash
flutter analyze
flutter test
```

> **Ghi chú**: Kết quả kiểm thử thực tế và ảnh chụp màn hình chạy thử nghiệm đã được lưu sẵn trong thư mục `verification/` của từng bài.
