#!/bin/bash
# Script để test FCM notification trực tiếp

echo "🔍 Testing FCM Notification..."
echo ""

# FCM Token từ logs
FCM_TOKEN="eAFLin5BRTyDYlADA9ZCwQ:APA91bFzQZi2itnu47BAoZjB9cLRTctCPZxd7v4z3To_KGmNyoBVeYXRURgLB6gH2noHo3CLQZYUG7GLRljJuK-doFCw-7iRmfxw6yMpLBQ23kVr8TMyRmM"

# Server Key từ google-services.json (cần lấy từ Firebase Console)
# Lưu ý: Đây là API key, không phải Server Key
echo "⚠️  LƯU Ý: Cần Server Key từ Firebase Console để test"
echo "   Vào Firebase Console > Project Settings > Cloud Messaging > Server Key"
echo ""
echo "📋 FCM Token hiện tại:"
echo "$FCM_TOKEN"
echo ""
echo "📝 Để test notification, cần:"
echo "1. Lấy Server Key từ Firebase Console"
echo "2. Gửi POST request đến https://fcm.googleapis.com/fcm/send"
echo "3. Với headers: Authorization: key=YOUR_SERVER_KEY"
echo "4. Với body JSON có notification payload"
echo ""
echo "🔍 Đang kiểm tra logs real-time..."
echo "   (Nhấn Ctrl+C để dừng)"
echo ""

# Monitor logs real-time
adb logcat -c
adb logcat | grep -E "FCM|LOCAL NOTI|Firebase|Notification|Background"


