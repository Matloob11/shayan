# Syed Shayan

Flutter wrapper for [SyedShayan.com](https://syedshayan.com/). The app loads the live site in a WebView and keeps the main public pages on a tab bar so visitors can move between Home, Portal, News, Research, and Contact without leaving the shell.

This is not a standalone CMS. Content, events, and layout still come from the website.

## What it does

- Opens `https://syedshayan.com/` and the matching site routes (`/web-portal.php`, `/news.php`, `/research-report.php`, `/contact.php`)
- Uses a navigation rail on wide screens and a bottom bar on phones
- Shows a loading overlay while a page is fetching
- Can request published events from `https://syedshayan.com/admin_api.php?action=get_events&status=published` (the repository injects `RemoteEventsRepository`; the home screen does not currently render that list)

## Stack

| Piece | Version / note |
| --- | --- |
| Flutter / Dart | SDK `>=3.3.0 <4.0.0` |
| WebView | `webview_flutter`, `webview_flutter_web` |
| HTTP | `http` |
| Targets | Android, iOS, Web, Windows, Linux, macOS |
| CI | `codemagic.yaml` workflow `flutter-ios-unsigned` |

Package name in `pubspec.yaml` is `syed_shayan_app`.

## Requirements

- Flutter SDK that matches the Dart constraint above
- Xcode + CocoaPods for iOS
- Android Studio / SDK for Android

## Run locally

```bash
flutter pub get
flutter run
```

Pick a device with `flutter devices`. For iOS:

```bash
cd ios && pod install && cd ..
flutter run -d ios
```

## Build

```bash
flutter build apk
flutter build ios --debug --no-codesign
flutter build web
```

Codemagic runs `flutter pub get`, `pod install` under `ios/`, then `flutter build ios --debug --no-codesign`. Flutter sources live at the repository root (`pubspec.yaml`, `lib/`, `android/`, `ios/`).

## Layout

```text
lib/                 App shell, tabs, WebView, event repository
assets/              Home / footer images
android/ ios/ web/   Platform projects
windows/ linux/ macos/
codemagic.yaml       Unsigned iOS debug build
test/                Flutter tests
```

## Notes

- There is no `.env`. The site URL is compiled into the app.
- If SyedShayan.com is down, the WebView has nothing to show.
- Preview image: `preview.png`

## License

See the repository. Not published on pub.dev (`publish_to: "none"`).
