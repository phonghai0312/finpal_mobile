# Fix iOS Build Errors

## Lỗi: "Command PhaseScriptExecution failed with a nonzero exit code"

### ✅ ĐÃ SỬA: GoogleService-Info.plist đã được thêm vào Xcode project

### Nguyên nhân phổ biến:
1. **Pods chưa được install hoặc không đồng bộ** ⚠️ CẦN KIỂM TRA
2. **GoogleService-Info.plist chưa được thêm vào Xcode project** ✅ ĐÃ SỬA
3. **Flutter build cache bị lỗi**

### Cách sửa (thực hiện theo thứ tự):

#### Bước 1: Clean và reinstall Pods
```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
pod cache clean --all
pod install
cd ..
```

#### Bước 2: Clean Flutter build
```bash
flutter clean
flutter pub get
```

#### Bước 3: Đảm bảo GoogleService-Info.plist được thêm vào Xcode
1. Mở Xcode: `open ios/Runner.xcworkspace` (QUAN TRỌNG: phải mở .xcworkspace, KHÔNG phải .xcodeproj)
2. Trong Xcode, kiểm tra xem `GoogleService-Info.plist` có trong project navigator không
3. Nếu chưa có:
   - Right-click vào folder "Runner" trong project navigator
   - Chọn "Add Files to Runner..."
   - Chọn file `GoogleService-Info.plist` từ `ios/Runner/`
   - Đảm bảo chọn "Copy items if needed" và target "Runner" được check
   - Click "Add"

#### Bước 4: Verify Bundle ID khớp nhau
Bundle ID phải giống nhau ở 3 nơi:
1. **Xcode Project Settings**: `com.example.fridgeToForkAi`
2. **GoogleService-Info.plist**: `com.example.fridgeToForkAi` (key `BUNDLE_ID`)
3. **Firebase Console**: iOS app phải có Bundle ID `com.example.fridgeToForkAi`

#### Bước 5: Build lại
```bash
flutter build ios
# hoặc
flutter run
```

---

## Cách thay đổi Bundle ID (nếu cần)

### Bước 1: Thay đổi trong Xcode
1. Mở `ios/Runner.xcworkspace` trong Xcode
2. Chọn project "Runner" ở sidebar
3. Chọn target "Runner"
4. Vào tab "General" hoặc "Signing & Capabilities"
5. Thay đổi "Bundle Identifier" thành bundle ID mới
6. Lặp lại cho tất cả build configurations (Debug, Release, Profile)

### Bước 2: Cập nhật GoogleService-Info.plist
1. Vào Firebase Console
2. Tạo iOS app mới với bundle ID mới HOẶC cập nhật bundle ID của app hiện tại
3. Tải lại file `GoogleService-Info.plist` mới
4. Thay thế file cũ trong `ios/Runner/`

### Bước 3: Clean và rebuild
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
flutter build ios
```

---

## Kiểm tra nhanh Bundle ID hiện tại

Chạy lệnh này để xem bundle ID ở tất cả các nơi:
```bash
# Xcode project
grep "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj | grep -v "RunnerTests"

# GoogleService-Info.plist
grep "BUNDLE_ID" ios/Runner/GoogleService-Info.plist
```

Cả hai phải giống nhau!



