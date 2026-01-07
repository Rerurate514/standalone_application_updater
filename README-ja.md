# Standalone Application Updater
## はじめに
このDartパッケージは、スタンドアロンで動作するデスクトップアプリの最新版があるかを確認し、ダウンロードすることができるパッケージです。
この最新版というのは、GithubのReleasesを確認して、そのAssetをダウンロードするものです。

### Github-Releases命名規則
アプリ名 - OS名 - アーキテクチャ名

例：
| OS      | アーキテクチャ | 推奨ファイル名             | ビルドコマンド                     | 生成物のパス (プロジェクトルート基準)              |
| ----------- | ----------- | ----------------------- | ------------------------------- | ------------------------------------- |
| Windows | x64         | `*-windows-x64.zip`     | `flutter build windows`         | `build/windows/x64/runner/Release/`   |
| Windows | arm64       | `*-windows-arm64.zip`   | `flutter build windows --arm64` | `build/windows/arm64/runner/Release/` |
| macOS   | arm64       | `*-macos-arm64.dmg`     | `flutter build macos`           | `build/macos/Build/Products/Release/` |
| macOS   | x64         | `*-macos-x64.dmg`       | `flutter build macos`           | `build/macos/Build/Products/Release/` |
| macOS   | Universal   | `*-macos-universal.dmg` | `flutter build macos`           | `build/macos/Build/Products/Release/` |
| Linux   | x64         | `*-linux-x64.tar.gz`    | `flutter build linux`           | `build/linux/x64/release/bundle/`     |
| Linux   | arm64       | `*-linux-arm64.tar.gz`  | `flutter build linux --arm64`   | `build/linux/arm64/release/bundle/`   |

