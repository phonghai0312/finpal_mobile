# ⚠️ QUAN TRỌNG: Cấu hình Google Services

File `google-services.json` hiện tại chỉ là **placeholder** để app có thể build được.

## Để FCM hoạt động, bạn cần:

1. Vào [Firebase Console](https://console.firebase.google.com)
2. Chọn project của bạn (hoặc tạo mới)
3. Vào **Project Settings** > **Your apps**
4. Chọn Android app (package name: `com.example.fridge_to_fork_ai`) hoặc thêm mới
5. **Download** file `google-services.json`
6. **Thay thế** file `android/app/google-services.json` bằng file đã download

## Lưu ý:
- File này chứa thông tin nhạy cảm, nên có thể thêm vào `.gitignore` nếu cần
- Sau khi thay file, chạy lại `flutter clean` và `flutter pub get`
