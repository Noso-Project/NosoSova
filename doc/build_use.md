# NosoSova Building


## Getting Started

Follow these steps to set up and build the project for various platforms.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- IDE (e.g., [Visual Studio Code](https://code.visualstudio.com/) with Flutter/Dart extension)

### Setting up the build environment

Follow the instructions in this guide [Installation Flutter](https://docs.flutter.dev/get-started/install/windows)

### Clone the Repository

```bash
git clone https://github.com/Noso-Project/NosoSova.git
cd NosoSova
```

### Install Dependencies

```bash
flutter pub get
```

### Build for Linux or Windows

```bash
# Linux
flutter build linux

# Windows
flutter build windows
```

### Build for IOS or Macos

```bash
# IOS
cd ios
pod install
cd ..
flutter build ios

# Macos
cd macos
pod install
cd ..
flutter build macos
```


### Build for Android

```bash
flutter build android
```

### Ways to get an assembly file

```bash
# Android
NosoSova/build/app/outputs/apk/flutter-apk/app-release.apk

# Windows
NosoSova\build\windows\runner\Release

# Linux
NosoSova/build/linux/x64/release/bundle/

# Macos
NosoSova/build/macos/Build/Products/NosoSova/
```
