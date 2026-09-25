#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .build/arm64 .build/x86_64 dist/QuietPin.app/Contents/MacOS dist/QuietPin.app/Contents/Resources
sdk="${SDKROOT:-$(xcrun --show-sdk-path)}"
for arch in arm64 x86_64; do
    swiftc -swift-version 5 -O -target "$arch-apple-macosx13.0" -sdk "$sdk" \
        -parse-as-library -emit-module -emit-library -static -module-name QuietPinCore \
        Sources/QuietPinCore/Notebook.swift -emit-module-path ".build/$arch/QuietPinCore.swiftmodule" \
        -o ".build/$arch/libQuietPinCore.a"
    swiftc -swift-version 5 -O -target "$arch-apple-macosx13.0" -sdk "$sdk" -parse-as-library \
        -I ".build/$arch" -L ".build/$arch" -lQuietPinCore Sources/QuietPin/*.swift \
        -o ".build/$arch/QuietPin"
done
lipo -create .build/arm64/QuietPin .build/x86_64/QuietPin -output dist/QuietPin.app/Contents/MacOS/QuietPin
cp packaging/Info.plist dist/QuietPin.app/Contents/Info.plist
cp assets/GitHub_Invertocat_Black.png dist/QuietPin.app/Contents/Resources/GitHub_Invertocat_Black.png
cp assets/GitHub_Invertocat_White.png dist/QuietPin.app/Contents/Resources/GitHub_Invertocat_White.png
swift scripts/make-icon.swift
iconutil -c icns .build/QuietPin.iconset -o dist/QuietPin.app/Contents/Resources/QuietPin.icns
codesign --force --sign - dist/QuietPin.app
codesign --verify --deep --strict dist/QuietPin.app
stage="$(mktemp -d "${TMPDIR:-/tmp}/quietpin-dmg.XXXXXX")"
ditto dist/QuietPin.app "$stage/QuietPin.app"
ln -s /Applications "$stage/Applications"
cp packaging/安装说明.txt "$stage/安装说明.txt"
hdiutil create -volname QuietPin -srcfolder "$stage" -ov -format UDZO dist/QuietPin-1.0.2-macOS-universal.dmg
printf 'Built: %s/dist/QuietPin.app\nBuilt: %s/dist/QuietPin-1.0.2-macOS-universal.dmg\n' "$PWD" "$PWD"
