#!/bin/bash

# Script để fix lỗi "Framework 'Pods_Runner' not found"

set -e

echo "🔧 Đang fix lỗi Pods_Runner framework..."

cd "$(dirname "$0")"

echo "📦 Bước 1: Clean Pods và cache..."
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf ~/Library/Developer/Xcode/DerivedData/*

echo "🧹 Bước 2: Clean pod cache..."
pod cache clean --all || true

echo "📥 Bước 3: Flutter clean..."
cd ..
flutter clean
flutter pub get
cd ios

echo "🔨 Bước 4: Install Pods..."
pod deintegrate || true
pod install --repo-update

echo "✅ Hoàn thành!"
echo ""
echo "📝 QUAN TRỌNG:"
echo "1. Đóng Xcode nếu đang mở"
echo "2. Mở lại bằng: open ios/Runner.xcworkspace"
echo "3. KHÔNG mở Runner.xcodeproj, chỉ mở .xcworkspace"
echo "4. Clean Build Folder trong Xcode (Cmd+Shift+K)"
echo "5. Build lại (Cmd+B)"


