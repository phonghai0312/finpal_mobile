# Fix lỗi "Framework 'Pods_Runner' not found"

## Nguyên nhân:
Lỗi này xảy ra khi:
1. **Pods chưa được build** - Framework `Pods_Runner.framework` chỉ được tạo khi build Pods project
2. **Đang mở sai file** - Phải mở `.xcworkspace`, KHÔNG phải `.xcodeproj`
3. **Pods chưa được install đúng cách**

## Cách sửa:

### Bước 1: Clean và reinstall Pods
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks
pod cache clean --all
pod deintegrate
pod install --repo-update
```

### Bước 2: Clean Flutter
```bash
cd ..
flutter clean
flutter pub get
```

### Bước 3: QUAN TRỌNG - Mở đúng file trong Xcode
**PHẢI mở:** `ios/Runner.xcworkspace`  
**KHÔNG mở:** `ios/Runner.xcodeproj`

```bash
open ios/Runner.xcworkspace
```

### Bước 4: Trong Xcode
1. **Clean Build Folder**: `Cmd + Shift + K` (hoặc Product > Clean Build Folder)
2. **Close Xcode** hoàn toàn
3. **Mở lại** `Runner.xcworkspace`
4. **Build** project: `Cmd + B`

### Bước 5: Nếu vẫn lỗi - Build Pods project trước
1. Trong Xcode, mở `Runner.xcworkspace`
2. Trong Project Navigator, tìm và mở `Pods` project
3. Chọn scheme `Pods-Runner`
4. Build (Cmd + B)
5. Sau đó build lại `Runner` project

## Kiểm tra:
Sau khi build thành công, framework sẽ được tạo tại:
```
ios/Pods/Pods_Runner.framework
```

Hoặc trong DerivedData:
```
~/Library/Developer/Xcode/DerivedData/Runner-*/Build/Products/Debug-iphonesimulator/Pods_Runner.framework
```

## Lưu ý:
- **LUÔN LUÔN** mở `.xcworkspace`, không bao giờ mở `.xcodeproj` khi dùng CocoaPods
- Nếu build từ command line, dùng: `flutter build ios` (không build trực tiếp từ Xcode nếu chưa chắc)
- Đảm bảo iOS deployment target đã được set đúng (15.0)


