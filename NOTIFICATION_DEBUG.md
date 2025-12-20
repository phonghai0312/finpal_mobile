# 🔍 Hướng dẫn Debug Notification trên Android Emulator

## ⚠️ Vấn đề phổ biến với Android Emulator

### 1. **Android Emulator không có Google Play Services**
- **Triệu chứng**: FCM token không được tạo hoặc null
- **Giải pháp**: 
  - Sử dụng emulator có Google Play (không phải Google APIs)
  - Hoặc cài Google Play Services thủ công
  - Kiểm tra: Settings > Apps > Google Play Services

### 2. **Notification không hiển thị khi app ở background/killed**
- **Nguyên nhân**: Backend gửi chỉ có `data` payload, không có `notification` payload
- **Giải pháp**: Backend phải gửi cả `notification` payload:
  ```json
  {
    "notification": {
      "title": "Test",
      "body": "Test notification"
    },
    "data": {
      "key": "value"
    }
  }
  ```

### 3. **Permission chưa được cấp**
- **Triệu chứng**: Log hiển thị "Notification permission denied"
- **Giải pháp**: 
  - Vào Settings > Apps > fridge_to_fork_ai > Notifications
  - Bật notifications
  - Hoặc chạy lại app và chấp nhận permission dialog

### 4. **Notification Channel chưa được tạo**
- **Triệu chứng**: Notification không hiển thị trên Android 8.0+
- **Giải pháp**: 
  - Kiểm tra log: `[LOCAL NOTI] ✅ Notification channel created`
  - Vào Settings > Apps > fridge_to_fork_ai > Notifications
  - Kiểm tra channel "High Importance Notifications" đã được tạo

## 📋 Checklist Debug

### ✅ Bước 1: Kiểm tra Firebase Setup
- [ ] `google-services.json` đã được thêm vào `android/app/`
- [ ] Google Services plugin đã được apply trong `build.gradle.kts`
- [ ] Log hiển thị: `[MAIN] ✅ Firebase initialized successfully`

### ✅ Bước 2: Kiểm tra FCM Initialization
- [ ] Log hiển thị: `[FCM] ✅ FCM service initialized successfully`
- [ ] Log hiển thị: `[FCM] 🔑 FCM Token: ...` (không phải null)
- [ ] Log hiển thị: `[LOCAL NOTI] ✅ Initialized successfully`

### ✅ Bước 3: Kiểm tra Permission
- [ ] Log hiển thị: `[FCM] 📱 Permission status: AuthorizationStatus.authorized`
- [ ] Settings > Apps > Notifications đã bật

### ✅ Bước 4: Kiểm tra Token Registration
- [ ] Sau khi login, log hiển thị: `[DEBUG FCM] Đăng ký FCM token thành công`
- [ ] Backend nhận được token và lưu vào database

### ✅ Bước 5: Kiểm tra Backend Gửi Notification
- [ ] Backend gửi với format đúng (có `notification` payload)
- [ ] Backend gửi đến đúng FCM token
- [ ] Backend log hiển thị gửi thành công

### ✅ Bước 6: Kiểm tra App Nhận Notification
- [ ] **Foreground**: Log hiển thị `[FCM] 📨 Foreground message received`
- [ ] **Background**: Log hiển thị `[FCM Background] 📨 Nhận notification`
- [ ] **Killed**: Log hiển thị `[FCM Background] 📨 Nhận notification`

## 🐛 Debug Commands

### Xem logs FCM:
```bash
flutter run
# Hoặc
adb logcat | grep -E "FCM|LOCAL NOTI|FCM Background"
```

### Kiểm tra FCM token:
- Xem log khi app khởi động: `[FCM] 🔑 FCM Token: ...`
- Xem log sau khi login: `[DEBUG FCM] FCM token từ Firebase: ...`

### Test notification thủ công:
```bash
# Gửi test notification từ Firebase Console
# Hoặc dùng curl:
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "FCM_TOKEN",
    "notification": {
      "title": "Test",
      "body": "Test notification"
    }
  }'
```

## 🔧 Các vấn đề đã được sửa

1. ✅ Background handler hiển thị notification
2. ✅ Foreground handler hiển thị notification
3. ✅ Xử lý cả notification payload và data-only payload
4. ✅ Thêm logging chi tiết để debug
5. ✅ Firebase Messaging Service đã được thêm vào AndroidManifest

## 📝 Lưu ý quan trọng

1. **Android Emulator**: Một số emulator không hỗ trợ đầy đủ Google Play Services. Nên test trên thiết bị thật hoặc emulator có Google Play.

2. **Notification Payload**: FCM tự động hiển thị notification khi có `notification` payload. Nếu chỉ có `data` payload, cần xử lý thủ công.

3. **Background Handler**: Chạy trong isolate riêng, không thể truy cập UI hoặc state của app chính.

4. **Permission**: Android 13+ (API 33+) cần runtime permission. App sẽ tự động request khi khởi động.


