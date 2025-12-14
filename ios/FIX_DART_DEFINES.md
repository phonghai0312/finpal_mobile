# Hướng dẫn sửa lỗi "Improperly formatted define flag"

## Nguyên nhân
Lỗi này xảy ra khi `DART_DEFINES` hoặc `--dart-define` flags có format sai trong Xcode.

## Cách kiểm tra và sửa

### 1. Kiểm tra Build Settings trong Xcode

1. Mở `ios/Runner.xcworkspace` trong Xcode
2. Chọn project **Runner** trong Project Navigator
3. Chọn target **Runner**
4. Vào tab **Build Settings**
5. Tìm kiếm `DART_DEFINES` trong search box
6. Nếu tìm thấy, kiểm tra format:
   - ✅ ĐÚNG: `KEY1=value1,KEY2=value2`
   - ❌ SAI: `KEY1value1` (thiếu dấu `=`)
   - ❌ SAI: `KEY1=value1, KEY2=value2` (có khoảng trắng sau dấu phẩy)
   - ❌ SAI: `KEY1=value with spaces` (cần encode nếu có khoảng trắng)

### 2. Kiểm tra Scheme Arguments

1. Trong Xcode, chọn **Product > Scheme > Edit Scheme...**
2. Chọn **Run** ở sidebar bên trái
3. Vào tab **Arguments**
4. Kiểm tra phần **Arguments Passed On Launch**
5. Tìm các flags bắt đầu với `--dart-define=`
6. Đảm bảo format đúng:
   - ✅ ĐÚNG: `--dart-define=KEY1=value1`
   - ✅ ĐÚNG: `--dart-define=KEY2=value2`
   - ❌ SAI: `--dart-define KEY1=value1` (thiếu dấu `=`)
   - ❌ SAI: `--dart-define=KEY1 value1` (có khoảng trắng)

### 3. Xóa DART_DEFINES nếu không cần thiết

Nếu bạn không sử dụng `--dart-define`, hãy xóa tất cả:
- Xóa `DART_DEFINES` trong Build Settings (để trống)
- Xóa tất cả `--dart-define=...` trong Scheme Arguments

### 4. Format đúng cho DART_DEFINES

Nếu bạn cần sử dụng DART_DEFINES:

**Trong Build Settings:**
```
KEY1=value1,KEY2=value2,KEY3=value3
```
- Không có khoảng trắng sau dấu phẩy
- Mỗi key-value pair cách nhau bởi dấu phẩy
- Không có khoảng trắng xung quanh dấu `=`

**Trong Scheme Arguments:**
```
--dart-define=KEY1=value1
--dart-define=KEY2=value2
```
- Mỗi define là một argument riêng biệt
- Format: `--dart-define=KEY=VALUE`

### 5. Nếu vẫn lỗi

1. Clean build folder: **Product > Clean Build Folder** (Shift+Cmd+K)
2. Xóa Derived Data:
   - **Xcode > Settings > Locations**
   - Click mũi tên bên cạnh Derived Data path
   - Xóa folder của project
3. Chạy lại:
   ```bash
   cd ios
   pod install
   cd ..
   flutter clean
   flutter pub get
   ```

## Lưu ý

- Nếu bạn dùng `flutter_dotenv` để load `.env` file, bạn KHÔNG cần `--dart-define`
- `--dart-define` chỉ cần khi bạn muốn pass values từ command line hoặc CI/CD
- Format mới của Flutter yêu cầu encode các giá trị đặc biệt (URLs, JSON, v.v.)









