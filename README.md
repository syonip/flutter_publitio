# Publit.io plugin for Flutter

A Flutter plugin that wraps the native [Publit.io API](https://publit.io?fpr=jonathan43) SDKs, for hosting and managing media assets (videos and images).


## Getting started

See the `example` directory for a complete sample app showing video upload and playback. Works on iOS and Android.

> For a more advance example, check out https://github.com/syonip/flutter_video_sharing

To run the example app you'll need credentials:
1. Create a free account at [Publit.io](https://publit.io?fpr=jonathan43), and get your credentials from the dashboard.
2. Put your API key and secret in `example/ios/Runner/Info.plist`, and in `example/lib/main.dart` (replace the text `"YOUR_API_KEY"` and `"YOUR_API_SECRET"` respectively)
3. Run the example by typing `flutter run` from the `example` directory.

## Usage

Add `flutter_publitio` as a dependency in your `pubspec.yaml`.

### Configure

```dart
await FlutterPublitio.configure("YOUR_API_KEY", "YOUR_API_SECRET");
```

### Upload

```dart
final uploadOptions = {
    "privacy": "1", // Marks file as publicly accessible
    "option_download": "1", // Can be downloaded by anyone
    "option_transform": "1" // Url transforms enabled
};
final response = await FlutterPublitio.uploadFile("file path", uploadOptions);

print(response["url_preview"]);
```

## Features

This plugin currently supports the `uploadFile` function. If you need more functions, please let me know by opening an issue (or make a PR 😜)