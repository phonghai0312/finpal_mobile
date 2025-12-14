#!/bin/bash

# Script để kiểm tra và sửa lỗi DART_DEFINES format

echo "🔍 Kiểm tra DART_DEFINES trong Xcode project..."

# Kiểm tra trong Build Settings
echo ""
echo "1. Kiểm tra Build Settings:"
DART_DEFINES_IN_BUILD=$(xcodebuild -showBuildSettings -project Runner.xcodeproj -scheme Runner -configuration Debug 2>/dev/null | grep "DART_DEFINES" || echo "")

if [ -z "$DART_DEFINES_IN_BUILD" ]; then
    echo "   ✅ Không tìm thấy DART_DEFINES trong Build Settings"
else
    echo "   ⚠️  Tìm thấy DART_DEFINES: $DART_DEFINES_IN_BUILD"
    # Kiểm tra format
    if [[ "$DART_DEFINES_IN_BUILD" =~ .*[^=]=[^,].* ]] && [[ ! "$DART_DEFINES_IN_BUILD" =~ .*\s.* ]]; then
        echo "   ✅ Format có vẻ đúng"
    else
        echo "   ❌ Format có vẻ sai! Vui lòng kiểm tra trong Xcode Build Settings"
    fi
fi

# Kiểm tra trong Scheme
echo ""
echo "2. Kiểm tra Scheme Arguments:"
SCHEME_FILE="Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme"
if [ -f "$SCHEME_FILE" ]; then
    DART_DEFINES_IN_SCHEME=$(grep -i "dart-define" "$SCHEME_FILE" || echo "")
    if [ -z "$DART_DEFINES_IN_SCHEME" ]; then
        echo "   ✅ Không tìm thấy --dart-define trong Scheme Arguments"
    else
        echo "   ⚠️  Tìm thấy --dart-define trong Scheme:"
        echo "   $DART_DEFINES_IN_SCHEME"
        echo "   Vui lòng kiểm tra format trong Xcode: Product > Scheme > Edit Scheme > Run > Arguments"
    fi
else
    echo "   ⚠️  Không tìm thấy scheme file"
fi

# Kiểm tra environment variables
echo ""
echo "3. Kiểm tra Environment Variables:"
if [ -n "$DART_DEFINES" ]; then
    echo "   ⚠️  Tìm thấy DART_DEFINES trong environment: $DART_DEFINES"
    # Kiểm tra format
    if [[ "$DART_DEFINES" =~ .*[^=]=[^,].* ]] && [[ ! "$DART_DEFINES" =~ .*\s.* ]]; then
        echo "   ✅ Format có vẻ đúng"
    else
        echo "   ❌ Format có vẻ sai!"
        echo "   Format đúng: KEY1=value1,KEY2=value2 (không có khoảng trắng)"
    fi
else
    echo "   ✅ Không có DART_DEFINES trong environment"
fi

echo ""
echo "📝 Hướng dẫn sửa lỗi:"
echo "   1. Mở ios/Runner.xcworkspace trong Xcode"
echo "   2. Chọn Runner > Build Settings > tìm 'DART_DEFINES'"
echo "   3. Nếu có, đảm bảo format: KEY1=value1,KEY2=value2 (không có khoảng trắng)"
echo "   4. Product > Scheme > Edit Scheme > Run > Arguments"
echo "   5. Kiểm tra các --dart-define=... flags"
echo "   6. Xem chi tiết trong ios/FIX_DART_DEFINES.md"
echo ""










