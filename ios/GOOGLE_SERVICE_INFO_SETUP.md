# GoogleService-Info.plist Setup

## ⚠️ QUAN TRỌNG: File này BẮT BUỘC để Firebase hoạt động trên iOS

### Cách thêm GoogleService-Info.plist:

1. **Tải file từ Firebase Console:**
   - Đăng nhập vào [Firebase Console](https://console.firebase.google.com/)
   - Chọn project của bạn
   - Vào **Project Settings** (⚙️) > **General**
   - Scroll xuống phần **Your apps**
   - Nếu chưa có iOS app, click **Add app** > chọn iOS
   - Nhập Bundle ID: `com.example.fridgeToForkAi`
   - Tải file `GoogleService-Info.plist`

2. **Thêm file vào project:**
   - Copy file `GoogleService-Info.plist` vào thư mục: `ios/Runner/`
   - Mở Xcode project: `ios/Runner.xcworkspace`
   - Kéo thả file vào Xcode project (đảm bảo chọn "Copy items if needed")
   - Đảm bảo file được thêm vào target "Runner"

3. **Verify:**
   - File phải nằm tại: `ios/Runner/GoogleService-Info.plist`
   - File phải được thêm vào Xcode project
   - Build lại project để kiểm tra

### Lưu ý:
- File này chứa thông tin nhạy cảm, KHÔNG commit vào git nếu chứa production credentials
- Nếu dùng development và production environments khác nhau, có thể cần 2 file khác nhau




