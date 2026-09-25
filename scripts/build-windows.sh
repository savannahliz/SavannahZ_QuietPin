#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
dotnet_bin="${DOTNET_BIN:-.tools/dotnet/dotnet}"
if [ ! -x "$dotnet_bin" ]; then dotnet_bin="$(command -v dotnet)"; fi
export DOTNET_CLI_TELEMETRY_OPTOUT=1
"$dotnet_bin" run --project windows/Tests/CoreChecks.csproj -c Release
"$dotnet_bin" publish windows/QuietPin.Windows.csproj -c Release -r win-x64 --self-contained true -o dist/windows-x64
cp dist/windows-x64/QuietPin.exe dist/QuietPin-1.0.2-Windows-x64.exe
cp packaging/Windows使用说明.txt dist/windows-x64/使用说明.txt
ditto -c -k --keepParent dist/windows-x64 dist/QuietPin-1.0.2-Windows-x64.zip
