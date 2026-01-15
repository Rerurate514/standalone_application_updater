# Standalone Application Updater
日本語版READMEはこれ -> https://github.com/Rerurate514/standalone_application_updater/blob/main/README-ja.md

## ⚠️ Important Note
While this package includes code to launch the application after downloading the latest version, this launch functionality is currently implemented only for Windows.
For macOS and Linux, the current version only supports checking for updates and downloading the assets.

Contributions (PRs) for macOS and Linux are highly welcome!
The groundwork is already laid, so adding the platform-specific launch logic should be straightforward.

## Introduction
This Dart package allows standalone desktop applications to check for updates and download them directly from GitHub Releases. It identifies the latest version by checking GitHub Release tags and downloads the corresponding assets.

For applications distributed outside of official app stores, this package provides end-to-end support for:

* Version checking
* Downloading assets
* Verification (Integrity check)
* Application execution (Extraction, Installation, etc.)

Update Workflow:

1. Check: Verify if a newer version exists.
2. Download: Pull the latest asset from GitHub.
* SHA256: Validate file integrity.

3. Execute: Launch the updated app.
* Handles file extraction and installation.

## Usage Example

```dart
// Configure package settings
final config = SauConfig(
  enableLogging: false,
);

// Get package instance
final updater = StandaloneApplicationUpdater.instance;

// Check if a new tag exists on GitHub Releases.
// It compares the current app's pubspec version with GitHub release tags.
// Supported tag formats: x.x.x or vx.x.x (e.g., 1.2.3 or v1.2.3)
final updateCheckResult = await updater.checkForUpdates(
  RepositoryInfo(owner: "OWNER_NAME", repoName: "REPO_NAME"), 
  config
);

// Start download if an update is available.
if(updateCheckResult is UpdateCheckAvailable) {
  final downloadResult = await updater.downloadUpdate(
    updateCheckResult, 
    config, 
    savePath: "PATH_TO_SAVE"
  );

  switch(downloadResult) {
    case DownloadUpdateSuccess(): {
      print("Download successful");

      final isSHA256Valid = await updater.checkSha256(downloadResult, config);
      switch(isSHA256Valid) {
        case Sha256CheckValid(): {
          print("SHA256 integrity verified");
          // On Windows, provide the path to the executable inside the zip.
          updater.applyUpdate(
            downloadResult, 
            "release/app.exe", 
            config,
            isAutoExit: true //  If true, the app will automatically close after startup.
          );
        }
        case Sha256CheckInvalid(): {
          print("SHA256 mismatch.");
        }
        case Sha256CheckNotExist(): {
          print("SHA256 file not found at the specified path.");
        }
        case Sha256CheckFailed(): {
          print("An error occurred while downloading the SHA256 file.");
        }
      }
    }
    case DownloadUpdateFailure(): {
      print("Download failed: ${downloadResult}");
    }
  }
} 

// Example using Stream to track progress
if(updateCheckResult is UpdateCheckAvailable) {
  updater.downloadUpdateStream(updateCheckResult, config).listen((downloadResult) {
    switch(downloadResult) {
      case DownloadUpdateStreamProgress(): {
        print("${downloadResult.downloadProgress.percentage}% downloaded");
      }
      case DownloadUpdateStreamSuccess(): {
        print("Saved to: ${downloadResult.savePath}");
        // Proceed with integrity check and application execution...
      }
      case DownloadUpdateStreamFailure(): {
        print("Error: ${downloadResult.message}");
      }
    }
  });
}

```

## Expected Exceptions
| Exception | Description |
| --- | --- |
| `SauApiRequestException` | Failed GitHub API request (Network offline, Rate limit, Repository not found, etc.). |
| `SauJsonDeserializationException` | Failed to parse the API response due to an unexpected format. |
| `SauUnsupportedOSException` | The current OS is not supported by this package. |
| `SauNotExistFileException` | Release exists, but no asset matching the current environment (OS/Arch) was found. |
| `SauDownloadException` | Connection lost during download or the URL is invalid. |
| `SauPermissionException` | No write permissions for the specified directory. |
| `SauArchiveException` | Failed to extract the downloaded archive (e.g., .zip). |

## Security
To ensure downloaded files are not tampered with or corrupted, the package supports SHA-256 hash verification.
If a `.sha256` file is included in the GitHub Release assets, the package will automatically perform an integrity check.
Requirement: The hash file must be named exactly as `[original_filename].sha256`.

### Recommended Hash Generation Commands
| OS | Command | Example (for `target.zip`) |
| --- | --- | --- |
| Windows | PowerShell | `Get-FileHash -Algorithm SHA256 .\target.zip | Select-Object -ExpandProperty Hash > target.zip.sha256` |
| macOS | shasum | `shasum -a 256 target.zip | awk '{print $1}' > target.zip.sha256` |
| Linux | sha256sum | `sha256sum target.zip | awk '{print $1}' > target.zip.sha256` |

## GitHub Releases Naming Convention
Format: `AppName - Version - OS - Architecture`

| OS | Architecture | Recommended Filename | Build Command | Output Path (from Project Root) |
| --- | --- | --- | --- | --- |
| Windows | x64 | `*-v1.0.0-windows-x64.zip` | `flutter build windows` | `build/windows/x64/runner/Release/` |
| Windows | arm64 | `*-v1.0.0-windows-arm64.zip` | `flutter build windows --arm64` | `build/windows/arm64/runner/Release/` |
| macOS | arm64 | `*-v1.0.0-macos-arm64.dmg` | `flutter build macos` | `build/macos/Build/Products/Release/` |
| macOS | x64 | `*-v1.0.0-macos-x64.dmg` | `flutter build macos` | `build/macos/Build/Products/Release/` |
| macOS | Universal | `*-v1.0.0-macos-universal.dmg` | `flutter build macos` | `build/macos/Build/Products/Release/` |
| Linux | x64 | `*-v1.0.0-linux-x64.tar.gz` | `flutter build linux` | `build/linux/x64/release/bundle/` |
| Linux | arm64 | `*-v1.0.0-linux-arm64.tar.gz` | `flutter build linux --arm64` | `build/linux/arm64/release/bundle/` |
