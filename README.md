# Quiz Battle Nepal

Quiz Battle Nepal is now a Flutter-only mobile app. The active application code lives in `lib/`, the Android host project lives in `android/`, and automated Flutter tests live in `test/`.

## Flutter project structure

- `lib/main.dart` starts the Flutter app.
- `lib/app.dart` configures the Material app, theme, and first screen.
- `lib/screens/` contains the app screens for splash, home, categories, quiz, results, leaderboard, and profile.
- `lib/widgets/` contains reusable Flutter UI widgets.
- `lib/services/` contains quiz, scoring, storage, explanation, and ad service logic.
- `lib/data/questions/` contains bundled JSON question banks declared as Flutter assets in `pubspec.yaml`.
- `android/` contains the Flutter Android embedding and Gradle configuration.

## Local development

Install Flutter, then run:

```bash
flutter pub get
flutter run
```

Useful checks:

```bash
flutter analyze
flutter test
```

## Android build

Create a debug APK with:

```bash
flutter build apk --debug
```

For release builds, configure signing in the Android project before distributing the app.

## AdMob integration

This repository includes a Google Mobile Ads integration layer that is disabled by default:

```dart
const bool useRealAds = false;
```

The implementation only uses Google's public test ad unit IDs. Do not replace them with production IDs until the app is ready for a policy review and the `useRealAds` flag is intentionally enabled.

### Startup

Call `await AdService.instance.initialize()` during app startup. The method is a no-op while `useRealAds` is false.

### Placement rules

- Use `AdMobBanner.home()` on the home page.
- Use `AdMobBanner.category()` on category pages.
- Call `AdService.instance.showInterstitialAfterQuizResultScreenOpens()` only after the quiz result screen has opened.
- Call `AdService.instance.showRewardedForUserAction(...)` only from explicit user taps for:
  - unlock full explanation
  - continue quiz
  - double coins

Interstitial ads must never be called from a quiz question screen, and rewarded ads must never appear without a user tap.
