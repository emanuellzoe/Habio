#!/bin/bash
set -e

SDK=$(xcrun --show-sdk-path --sdk macosx)
APP="Habio.app"
BINARY="$APP/Contents/MacOS/Habio"

echo "🔨 Building Habio..."

# Clean
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
mkdir -p "$APP/Contents/Resources"

# Compile all Swift sources
swiftc \
  -sdk "$SDK" \
  -target arm64-apple-macosx14.0 \
  -parse-as-library \
  -framework SwiftUI \
  -framework AppKit \
  -framework Foundation \
  -O \
  Habio/Models/Habit.swift \
  Habio/Models/HabitStore.swift \
  Habio/Models/AuthStore.swift \
  Habio/Views/ProgressRing.swift \
  Habio/Views/SidebarView.swift \
  Habio/Views/HabitCard.swift \
  Habio/Views/DashboardView.swift \
  Habio/Views/LoginView.swift \
  Habio/Views/AddHabitView.swift \
  Habio/ContentView.swift \
  Habio/HabioApp.swift \
  -o "$BINARY"

# Write Info.plist
cat > "$APP/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>Habio</string>
  <key>CFBundleIdentifier</key>
  <string>com.habio.app</string>
  <key>CFBundleName</key>
  <string>Habio</string>
  <key>CFBundleDisplayName</key>
  <string>Habio</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
  <key>LSMinimumSystemVersion</key>
  <string>14.0</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSSupportsAutomaticGraphicsSwitching</key>
  <true/>
</dict>
</plist>
PLIST

echo "✅ Build succeeded!"
echo "🚀 Launching Habio..."
open "$APP"
