#!/bin/bash

# Script để fix lỗi iOS build
# Chạy: bash ios/fix_build.sh

set -e

echo "🔧 Đang fix iOS build errors..."

cd "$(dirname "$0")"

echo "📦 Bước 1: Clean Pods..."
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

echo "🧹 Bước 2: Clean pod cache..."
pod cache clean --all || true

echo "📥 Bước 3: Install Pods..."
pod install --repo-update

echo "✅ Hoàn thành! Bây giờ chạy: flutter clean && flutter pub get && flutter build ios"



