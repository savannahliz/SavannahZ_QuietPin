#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .build/tests
swiftc -swift-version 5 -parse-as-library -emit-module -emit-library -static -module-name QuietPinCore \
    Sources/QuietPinCore/Notebook.swift -emit-module-path .build/tests/QuietPinCore.swiftmodule -o .build/tests/libQuietPinCore.a
swiftc -swift-version 5 -parse-as-library -I .build/tests -L .build/tests -lQuietPinCore Tests/CoreChecks.swift -o .build/tests/CoreChecks
.build/tests/CoreChecks
swiftc -swift-version 5 -parse-as-library -I .build/tests -L .build/tests -lQuietPinCore Sources/QuietPin/Store.swift Tests/PaletteChecks.swift -o .build/tests/PaletteChecks
.build/tests/PaletteChecks
