# Standalone Application Updater
## はじめに
このDartパッケージは、スタンドアロンで動作するデスクトップアプリの最新版があるかを確認し、ダウンロードすることができるパッケージです。
この最新版というのは、GithubのReleasesのタグを確認して、そのAssetをダウンロードするものです。

## 使い方例
```dart
// パッケージコンフィグを設定
final config = SauConfig(
    enableLogging: false
);

// パッケージインスタンスの取得
final updater = StandaloneApplicationUpdater.instance;

// checkForUpdatesメソッドによって、Githubのrelease上に新しいタグが存在するかチェック
// この比較は実行しているアプリのpubspecとGithubのreleaseのタグを比較します。
// Githubタグはx.x.xまたはvx.x.xの形式です。(1.2.3 || v1.2.3)
final updateCheckResult = await updater.checkForUpdates(
    RepositoryInfo(owner: "Rerurate514", repoName: "mc_utility_translater"), 
    config
);

// downloadUpdateによってダウンロードを開始します。
// このとき、checkForUpdatesからUpdateCheckAvailableというクラスが返ってきた時だけ、ダウンロードできます。
// このUpdateCheckAvailableは最新版タグが存在している時だけ、かえってきます。
// もし、UpdateCheckUpToDateが返ってきた場合は、実行しているアプリが最新版です。
if(updateCheckResult is UpdateCheckAvailable) {
    final downloadResult = await updater.downloadUpdate(updateCheckResult, config);

    switch(downloadResult) {
        case DownloadUpdateSuccess(): print("ダウンロードの成功");
        case DownloadUpdateFailure(): print("ダウンロードの失敗");
    }
}

// ストリームでダウンロード進捗を取得
if(updateCheckResult is UpdateCheckAvailable) {
    updater.downloadUpdateStream(updateCheckResult,config).listen((downloadResult) {
        switch(downloadResult) {
            case DownloadUpdateStreamProgress(): {
                print(downloadResult.downloadProgress.percentage);
            }
            case DownloadUpdateStreamSuccess(): {
                print(downloadResult.savePath);
            }
            case DownloadUpdateStreamFailure(): {
                print(downloadResult.message);
            }
        }
    });
}
```

## 想定されるエラー
| 例外クラス名                            | 発生するシチュエーション                                         |
| ------------------------------------- | -------------------------------------------------------- |
| `SauApiRequestException`          | GitHub APIへのリクエストに失敗した場合（ネットワーク未接続、レート制限、リポジトリが存在しないなど）。 |
| `SauJsonDeserializationException` | APIからのレスポンス形式が予期しないもので、パースに失敗した場合。                       |
| `SauUnsupportedOSException`       | 実行環境のOSがパッケージのサポート対象外である場合。                              |
| `SauNotExistFileException`        | リリースは存在するが、現在の環境（OS/アーキテクチャ）に適合するアセットファイルが見つからない場合。      |
| `SauDownloadException`            | ファイルのダウンロード中に通信が切断された場合、またはURLが無効な場合。                    |
| `SauPermissionException`          | 指定された保存先ディレクトリに対して書き込み権限がない場合（管理者権限が必要な場所に保存しようとした際など）。  |
| `SauHashMismatchException`        | ダウンロード完了後、ファイルのハッシュ値が期待される値と一致しなかった場合（ファイル破損の可能性）。       |
| `SauArchiveException`             | ダウンロードしたアーカイブ（.zip等）の解凍処理に失敗した場合。                        |

## セキュリティ
ダウンロードしたファイルが改ざんされていないか、または破損していないかを検証するために、ハッシュ値（SHA-256）によるチェックをサポートしています。
GitHubのリリースアセットに `.sha256` 形式のファイルが含まれている場合、自動的に照合を行います。

## Github-Releases命名規則
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

