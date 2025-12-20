# 🔍 Chẩn đoán vấn đề Notification

## ✅ Các thứ đã hoạt động đúng:

1. **Firebase Initialization**: ✅
   - Log: `[MAIN] ✅ Firebase initialized successfully`

2. **FCM Service Initialization**: ✅
   - Log: `[FCM] ✅ FCM service initialized successfully`
   - Log: `[FCM] 🔑 FCM Token: eAFLin5BRTyDYlADA9ZCwQ:APA91bFzQZi2itnu47BAoZjB9cLRTctCPZxd7v4z3To_KGmNyoBVeYXRURgLB6gH2noHo3CLQZYUG7GLRljJuK-doFCw-7iRmfxw6yMpLBQ23kVr8TMyRmM`

3. **Permission**: ✅
   - `POST_NOTIFICATIONS: granted=true`
   - `AuthorizationStatus.authorized`

4. **Notification Channel**: ✅
   - Channel `high_importance_channel` đã được tạo
   - Importance: HIGH (4)

5. **Token Registration**: ✅
   - Log: `[DEBUG FCM] Đăng ký FCM token thành công`

6. **Google Play Services**: ✅
   - `com.google.android.gms` có sẵn

## ❌ Vấn đề phát hiện:

### 1. **Không có log nhận notification**
- Không thấy log: `[FCM] 📨 Foreground message received`
- Không thấy log: `[FCM Background] 📨 Nhận notification`

### 2. **Nguyên nhân có thể:**

#### A. Backend gửi notification không đúng format
Backend PHẢI gửi với format:
```json
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "Test",
    "body": "Test notification"
  },
  "data": {
    "key": "value"
  }
}
```

**LƯU Ý QUAN TRỌNG**: 
- Nếu chỉ có `data` payload → FCM KHÔNG tự động hiển thị notification
- Phải có `notification` payload để FCM tự động hiển thị
- Hoặc app phải xử lý `data` payload và hiển thị notification thủ công

#### B. Backend gửi đến sai FCM token
- Kiểm tra backend có dùng đúng token: `eAFLin5BRTyDYlADA9ZCwQ:APA91bFzQZi2itnu47BAoZjB9cLRTctCPZxd7v4z3To_KGmNyoBVeYXRURgLB6gH2noHo3CLQZYUG7GLRljJuK-doFCw-7iRmfxw6yMpLBQ23kVr8TMyRmM`
- Token có thể đã thay đổi sau khi đăng ký

#### C. Backend Server Key không đúng
- Kiểm tra backend có dùng đúng Server Key từ Firebase Console
- Server Key khác với API Key trong `google-services.json`

#### D. Network/Firewall issue
- Emulator có thể không kết nối được đến FCM servers
- Kiểm tra: `adb shell ping fcm.googleapis.com`

## 🔧 Các bước debug tiếp theo:

### 1. Kiểm tra backend gửi notification:
```bash
# Xem logs backend khi gửi notification
# Kiểm tra:
# - Request có đúng format không?
# - FCM token có đúng không?
# - Server Key có đúng không?
# - Response từ FCM có thành công không?
```

### 2. Test notification trực tiếp từ Firebase Console:
1. Vào Firebase Console > Cloud Messaging
2. Gửi test message đến FCM token
3. Kiểm tra xem có nhận được không

### 3. Test với curl (nếu có Server Key):
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "eAFLin5BRTyDYlADA9ZCwQ:APA91bFzQZi2itnu47BAoZjB9cLRTctCPZxd7v4z3To_KGmNyoBVeYXRURgLB6gH2noHo3CLQZYUG7GLRljJuK-doFCw-7iRmfxw6yMpLBQ23kVr8TMyRmM",
    "notification": {
      "title": "Test",
      "body": "Test notification"
    }
  }'
```

### 4. Monitor logs real-time:
```bash
adb logcat -c
adb logcat | grep -E "FCM|LOCAL NOTI|Firebase|Notification"
# Sau đó gửi notification từ backend
```

## 📝 Kết luận:

**App đã được setup đúng**, nhưng **không nhận được notification từ backend**. 

**Nguyên nhân có thể là:**
1. Backend gửi notification không đúng format (thiếu `notification` payload)
2. Backend gửi đến sai FCM token
3. Backend Server Key không đúng
4. Network issue giữa emulator và FCM servers

**Giải pháp:**
1. Kiểm tra backend logs khi gửi notification
2. Test notification từ Firebase Console trực tiếp
3. Kiểm tra format notification backend đang gửi
4. Đảm bảo backend gửi với `notification` payload


