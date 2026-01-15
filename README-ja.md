# Standalone Application Updater
## ！注意事項！
このパッケージには、最新版をダウンロードした後、起動するコードも含まれていますが、この機能はWindows限定で実装されています。
MACOSとLINUXは、最新版があるかどうかをチェックしてダウンロードするだけです。

MACOSとLINUXのPR待っています。
現状はコードを追加するだけで済むはずです。

## はじめに
このDartパッケージは、スタンドアロンで動作するデスクトップアプリの最新版があるかを確認し、ダウンロードすることができるパッケージです。
この最新版というのは、GithubのReleasesのタグを確認して、そのAssetをダウンロードするものです。

ストアを介さない配布形態において、最新バージョンのチェックから、ダウンロード、整合性の検証、そしてアプリの実行までを一貫してサポートします。

このパッケージは以下のステップで実行されます。
- 最新版があるかどうかチェック
- Githubアセットから最新版をダウンロード
  - SHA256の整合性チェック
- アプリの実行
  - ファイルの解凍、インストールなど

## 使い方例
```dart
// パッケージコンフィグを設定
final config = SauConfig(
  enableLogging: false,
  enableHashChecking: true
);

// パッケージインスタンスの取得
final updater = StandaloneApplicationUpdater.instance;

// checkForUpdatesメソッドによって、Githubのrelease上に新しいタグが存在するかチェック
// この比較は実行しているアプリのpubspecとGithubのreleaseのタグを比較します。
// Githubタグはx.x.xまたはvx.x.xの形式です。(1.2.3 || v1.2.3)
final updateCheckResult = await updater.checkForUpdates(
  RepositoryInfo(owner: "リポジトリのオーナー名", repoName: "リポジトリの名前"), 
  config
);

// downloadUpdateによってダウンロードを開始します。
// このとき、checkForUpdatesからUpdateCheckAvailableというクラスが返ってきた時だけ、ダウンロードできます。
// このUpdateCheckAvailableは最新版タグが存在している時だけ、かえってきます。
// もし、UpdateCheckUpToDateが返ってきた場合は、実行しているアプリが最新版です。
if(updateCheckResult is UpdateCheckAvailable) {
  final downloadResult = await updater.downloadUpdate(updateCheckResult, config, savePath: "ダウンロード先のパス");

  switch(downloadResult) {
    case DownloadUpdateSuccess(): {
      print("ダウンロードの成功");

      final isSHA256Valid = await updater.checkSha256(downloadResult, config);
      switch(isSHA256Valid) {
        case Sha256CheckValid(): {
          print("SHA256の整合性を確認");
          updater.applyUpdate(downloadResult, "Windowsターゲットならzip内の実行ファイルまでのパス。(例：release/app.exe)", config);
        }
        case Sha256CheckInvalid(): {
          print("SHA256が一致しません。");
        }
        case Sha256CheckNotExist(): {
          print("SHA256ファイルが指定されたパスにが存在しません。");
        }
        case Sha256CheckFailed(): {
          print("SHA256ファイルのダウンロード中に問題が発生しました。");
        }
      }
    }
    case DownloadUpdateFailure(): {
      print("ダウンロードの失敗 : ${downloadResult}");
    }
  }
} 

// ストリームでダウンロード進捗を取得するならこっち
if(updateCheckResult is UpdateCheckAvailable) {
  updater.downloadUpdateStream(updateCheckResult,config).listen((downloadResult) {
    switch(downloadResult) {
      case DownloadUpdateStreamProgress(): {
        print(downloadResult.downloadProgress.percentage);
      }
      case DownloadUpdateStreamSuccess(): {
        print(downloadResult.savePath);

        final isSHA256Valid = await updater.checkSha256(downloadResult, config);
        //ここから整合性チェックとアプリの実行までできます。
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
| `SauArchiveException`             | ダウンロードしたアーカイブ（.zip等）の解凍処理に失敗した場合。                        |

## セキュリティ
ダウンロードしたファイルが改ざんされていないか、または破損していないかを検証するために、ハッシュ値（SHA-256）によるチェックをサポートしています。
GitHubのリリースアセットに `.sha256` 形式のファイルが含まれている場合、自動的に照合を行います。
ただし、この場合は必ずリリースファイルに`.sha256`を付けたものにしてください。

おすすめ
| OS      | 使用するコマンド   | 実行例（ファイル名：target.zip の場合）                                                            |
| ----------- | -------------- | ---------------------------------------------------------------------------------------- |
| Windows | PowerShell | `Get-FileHash -Algorithm SHA256 .\target.zip \| Select-Object -ExpandProperty Hash > target.zip.sha256` |
| macOS   | shasum     | `shasum -a 256 target.zip \| awk '{print $1}' > target.zip.sha256`                       |
| Linux   | sha256sum  | `sha256sum target.zip \| awk '{print $1}' > target.zip.sha256`                           |

## Github-Releases命名規則
アプリ名 - バージョン - OS名 - アーキテクチャ名

例：
| OS      | アーキテクチャ | 推奨ファイル名             | ビルドコマンド                     | 生成物のパス (プロジェクトルート基準)              |
| ----------- | ----------- | ----------------------- | ------------------------------- | ------------------------------------- |
| Windows | x64         | `*-v1.0.0-windows-x64.zip`     | `flutter build windows`         | `build/windows/x64/runner/Release/`   |
| Windows | arm64       | `*-v1.0.0-windows-arm64.zip`   | `flutter build windows --arm64` | `build/windows/arm64/runner/Release/` |
| macOS   | arm64       | `*-v1.0.0-macos-arm64.dmg`     | `flutter build macos`           | `build/macos/Build/Products/Release/` |
| macOS   | x64         | `*-v1.0.0-macos-x64.dmg`       | `flutter build macos`           | `build/macos/Build/Products/Release/` |
| macOS   | Universal   | `*-v1.0.0-macos-universal.dmg` | `flutter build macos`           | `build/macos/Build/Products/Release/` |
| Linux   | x64         | `*-v1.0.0-linux-x64.tar.gz`    | `flutter build linux`           | `build/linux/x64/release/bundle/`     |
| Linux   | arm64       | `*-v1.0.0-linux-arm64.tar.gz`  | `flutter build linux --arm64`   | `build/linux/arm64/release/bundle/`   |

