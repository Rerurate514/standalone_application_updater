import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sau_platform.freezed.dart';

@freezed
sealed class SauPlatform with _$SauPlatform {
  const SauPlatform._();

  const factory SauPlatform.windowsX64() = SauPlatformWindowsX64;
  const factory SauPlatform.windowsArm64() = SauPlatformWindowsArm64;
  const factory SauPlatform.macosArm64() = SauPlatformMacosArm64;
  const factory SauPlatform.macosX64() = SauPlatformMacosX64;
  const factory SauPlatform.macosUniversal() = SauPlatformMacosUniversal;
  const factory SauPlatform.linuxX64() = SauPlatformLinuxX64;
  const factory SauPlatform.linuxArm64() = SauPlatformLinuxArm64;

  factory SauPlatform.current() {
    final arch = Platform.version.contains('arm64') || Platform.version.contains('aarch64') 
        ? 'arm64' 
        : 'x64';

    if (Platform.isWindows) {
      return arch == 'arm64' 
          ? const SauPlatform.windowsArm64() 
          : const SauPlatform.windowsX64();
    }

    if (Platform.isMacOS) {
      return arch == 'arm64' 
          ? const SauPlatform.macosArm64() 
          : const SauPlatform.macosX64();
    }

    if (Platform.isLinux) {
      return arch == 'arm64' 
          ? const SauPlatform.linuxArm64() 
          : const SauPlatform.linuxX64();
    }

    throw UnsupportedError('This platform is not supported by SAU.');
  }

  String get osIdentifier => when(
        windowsX64: () => 'windows',
        windowsArm64: () => 'windows',
        macosArm64: () => 'macos',
        macosX64: () => 'macos',
        macosUniversal: () => 'macos',
        linuxX64: () => 'linux',
        linuxArm64: () => 'linux',
      );

  String get archIdentifier => when(
        windowsX64: () => 'x64',
        windowsArm64: () => 'arm64',
        macosArm64: () => 'arm64',
        macosX64: () => 'x64',
        macosUniversal: () => 'universal',
        linuxX64: () => 'x64',
        linuxArm64: () => 'arm64',
      );

  String get fileExtension => when(
        windowsX64: () => '.zip',
        windowsArm64: () => '.zip',
        macosArm64: () => '.dmg',
        macosX64: () => '.dmg',
        macosUniversal: () => '.dmg',
        linuxX64: () => '.tar.gz',
        linuxArm64: () => '.tar.gz',
      );

  factory SauPlatform.fromFileName(String fileName) {
    final name = fileName.toLowerCase();

    if (name.contains('windows')) {
      if (name.contains('arm64')) return const SauPlatform.windowsArm64();
      if (name.contains('x64')) return const SauPlatform.windowsX64();
    }

    if (name.contains('macos')) {
      if (name.contains('universal')) return const SauPlatform.macosUniversal();
      if (name.contains('arm64')) return const SauPlatform.macosArm64();
      if (name.contains('x64')) return const SauPlatform.macosX64();
    }

    if (name.contains('linux')) {
      if (name.contains('arm64')) return const SauPlatform.linuxArm64();
      if (name.contains('x64')) return const SauPlatform.linuxX64();
    }

    if (name.contains('win64')) return const SauPlatform.windowsX64();
    if (name.contains('darwin') || name.contains('apple')) {
      if (name.contains('arm64')) return const SauPlatform.macosArm64();
      return const SauPlatform.macosX64();
    }

    throw UnsupportedError('Could not determine platform from file name: $fileName');
  }

  String buildFileName(String appName, String version) {
    return '$appName-v$version-$osIdentifier-$archIdentifier$fileExtension';
  }
}
