### Github-Releases命名規則
アプリ名 - OS名 - アーキテクチャ名

例：
|OS|アーキテクチャ|推奨されるファイル名（例）|拡張子のバリエーション|
|---|---|---|---|
|Windows|x64 (Intel/AMD)|`myapp-windows-x64.zip`|`.exe`, `.msi`|
|Windows|arm64|`myapp-windows-arm64.zip`|`.exe`, `.msi`|
|macOS|arm64 (Apple Silicon)|`myapp-macos-arm64.dmg`|`.pkg`, `.zip`|
|macOS|x64 (Intel)|`myapp-macos-x64.dmg`|`.pkg`, `.zip`|
|macOS|Universal (両対応)|`myapp-macos-universal.dmg`|`.pkg`|
|Linux|x64|`myapp-linux-x64.tar.gz`|`.AppImage`, `.deb`, `.rpm`|
|Linux|arm64|`myapp-linux-arm64.tar.gz`|`.AppImage`, `.deb`, `.rpm`|

