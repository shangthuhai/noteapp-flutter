# 📝 Smart Note App

Ứng dụng quản lý ghi chú thông minh được xây dựng bằng **Flutter**, hoạt động hoàn toàn ngoại tuyến (100% Offline). Dự án này tập trung vào trải nghiệm người dùng (UX) mượt mà với tính năng tự động lưu (Auto-save), quản lý trạng thái cục bộ và giao diện hiện đại theo phong cách Masonry Layout.

## ✨ Tính năng nổi bật (Features)

* **Tự động lưu (Auto-save):** Loại bỏ nút "Lưu" truyền thống. Dữ liệu tự động được mã hóa JSON và lưu xuống thiết bị ngay khi người dùng bấm Back hoặc vuốt thoát khỏi màn hình soạn thảo.
* **Lưu trữ Offline 100%:** Sử dụng `SharedPreferences` để lưu trữ dữ liệu vĩnh viễn trên thiết bị, đảm bảo dữ liệu không bị mất ngay cả khi khởi động lại máy hoặc tắt hoàn toàn ứng dụng (Kill App).
* **Tìm kiếm Tức thì (Real-time Search):** Lọc ghi chú ngay khi gõ từ khóa theo tiêu đề.
* **Thao tác vuốt để Xóa (Swipe to Delete):** Vuốt thẻ ghi chú sang trái để xóa, đi kèm hộp thoại (Dialog) xác nhận 2 lớp để tránh thao tác nhầm.
* **Bảng thống kê (Dashboard):** Thanh trạng thái màu xanh nhạt hiển thị nhanh các chỉ số: Tổng số ghi chú, số ghi chú tạo hôm nay, và số ghi chú vừa sửa.
* **Bộ lọc trạng thái (Filter Tabs):** Chuyển đổi nhanh giữa các chế độ xem: Tất cả, Mới nhất, Cũ nhất.
* **Thêm ảnh vào ghi chú (Filter Tabs):** Thêm ảnh từ bộ sưu tập
* **Thêm vẽ vào ghi chú (Filter Tabs):** Thêm ảnh vẽ vào trong ghi chú

## 🎨 Giao diện & Thiết kế (UI/UX)

* **Màu sắc chủ đạo:** Trắng mang lại cảm giác nhẹ nhàng, tập trung.
* **Bố cục lưới (Masonry Layout):** Danh sách ghi chú được hiển thị dạng lưới 2 cột so le, các thẻ (Card) có độ cao linh hoạt giãn theo nội dung, bo góc và đổ bóng nhẹ.
* **Trạng thái trống (Empty State):** Hiển thị hình ảnh minh họa mờ và lời chào thân thiện khi chưa có dữ liệu.
* **Soạn thảo không viền:** Màn hình chi tiết được thiết kế tối giản như một trang giấy trắng, ô nhập liệu tự động giãn nở (Multiline) theo chiều dài văn bản.

## 🛠 Công nghệ sử dụng (Tech Stack)

* **Framework:** Flutter (Dart)
* **Lưu trữ (Local Storage):** `shared_preferences`
* **Định dạng thời gian:** `intl`
* **Giao diện lưới:** `flutter_staggered_grid_view`
* **Xử lý dữ liệu:** JSON Serialization (jsonEncode / jsonDecode)

## 🚀 Hướng dẫn cài đặt (Getting Started)

**1. Clone hoặc tải mã nguồn về máy**

**2. Cài đặt các thư viện phụ thuộc:**
Mở terminal tại thư mục gốc của dự án và chạy lệnh:
```bash
flutter pub get
