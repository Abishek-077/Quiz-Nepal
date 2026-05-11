# Quiz Battle Nepal

**Quiz Battle Nepal** is an Android-first Flutter MVP for a Nepal-focused quiz/game app.

**Tagline:** Driving License, Loksewa, GK & AI Explanation Quiz App

The V1 product is intentionally local-first: no backend, no login, no Firebase, no payments, and no paid AI APIs. Questions and explanations load from JSON assets, progress is stored locally, and ad monetization touchpoints are represented by a mock AdMob service that can later be swapped for `google_mobile_ads`.

## Current MVP features

- Splash, home, category, quiz, result, profile/statistics, and leaderboard placeholder screens.
- Five V1 quiz categories:
  - Driving License MCQ
  - Traffic Signs
  - Loksewa GK
  - Computer Basics
  - Nepal General Knowledge
- 50 local sample questions total, with 10 questions per category.
- Each quiz uses up to 10 random questions.
- Four options per question.
- Correct/wrong answer highlighting.
- Score, hearts, and coins game loop:
  - 5 hearts at start.
  - Correct answer gives +10 score and +2 coins.
  - Wrong answer removes 1 heart.
  - Quiz ends after the final question or when hearts become 0.
- Result screen with score, correct answers, wrong answers, coins earned, best score, double-coins placeholder, and share placeholder.
- Local stats with `shared_preferences`:
  - `totalCoins`
  - `bestScore`
  - `quizzesPlayed`
  - `correctAnswers`
  - `currentStreak` placeholder
- Daily quiz placeholder logic based on the current date.
- Local explanation system:
  - Short explanation appears after a wrong answer.
  - Full explanation is unlocked by a mock rewarded ad.
- Mock ad service with:
  - `showRewardedAd()`
  - `showInterstitialAd()`
  - banner placeholder widget
- Rewarded placeholders for full explanation unlock, continuing after hearts finish, and doubling result coins.

## Production-readiness improvements in this pass

- Category metadata now lives in `CategoryCatalog`, so JSON loading is focused on question assets and no longer owns app navigation/category catalog decisions.
- `Question.fromJson` validates required fields, exactly four options, valid `correctIndex`, and empty string values before a question enters the quiz flow.
- `QuestionService` wraps asset/JSON failures in a readable `QuestionLoadException` and clamps quiz length to the available question count.
- The quiz screen now has explicit loading, empty, and error states instead of assuming JSON always loads successfully.
- Quiz actions guard against duplicate taps while finishing, unlocking explanations, and rewarded-continue flows are in progress.
- `QuizEngine` centralizes game constants and prevents answers after hearts reach zero until a rewarded continue restores hearts.
- Profile stats now show loading and error states instead of silently showing zeros during failures.

## Project structure

```text
lib/
  main.dart
  app.dart
  core/
    constants/
    theme/
  data/
    category_catalog.dart
    questions/
  models/
  services/
  screens/
  widgets/
test/
android/
```

## How to run

1. Install Flutter stable and Android Studio / Android SDK.
2. Ensure an Android emulator or device is available.
3. From the project root, run:

```bash
flutter pub get
flutter run
```

## Testing and checks

```bash
flutter analyze
flutter test
```

The app has unit tests for `Question.fromJson`, local JSON pack schema/category matching, and `QuizEngine` scoring/hearts/rewarded-continue logic.

## Android / Google Play notes

The Android Gradle configuration is Android-first and sets:

- `compileSdk = 35`
- `targetSdk = 35`
- `minSdk = 23`

This prepares the project for Android 15 / API level 35 or higher Google Play target requirements. Before production release, also add production signing, Play Store listing assets, privacy policy, data safety details, final package name validation, and real launcher/adaptive icons.

## Mock ads now, real AdMob later

V1 does **not** include real ads. It only uses Google test ad ID constants and a fake `AdMobService` that returns success after a short delay.

### Exact next steps to add real AdMob later

1. **Create an AdMob app and ad units**
   - Create the Android app in the AdMob console.
   - Create one rewarded ad unit for explanation/continue/double-coins rewards.
   - Create one interstitial ad unit for quiz completion.
   - Create one banner ad unit for home/category placements.
   - Keep the current Google test ad IDs in development builds.

2. **Add the Flutter plugin**

   ```bash
   flutter pub add google_mobile_ads
   ```

3. **Add the Android AdMob App ID**
   - Add the AdMob application ID to `android/app/src/main/AndroidManifest.xml` inside `<application>`:

   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy" />
   ```

4. **Initialize Mobile Ads**
   - In `lib/main.dart`, call `WidgetsFlutterBinding.ensureInitialized()` and then initialize Mobile Ads before `runApp`:

   ```dart
   await MobileAds.instance.initialize();
   ```

5. **Replace `AdMobService.showRewardedAd()`**
   - Load a `RewardedAd` with the rewarded test ad unit ID.
   - Show the ad only after it loads.
   - Return `true` only from the earned-reward callback.
   - Dispose the ad in full-screen content callbacks.
   - Keep one public method (`showRewardedAd({required String placement})`) so quiz/result screens do not need to know ad SDK details.

6. **Replace `AdMobService.showInterstitialAd()`**
   - Load an `InterstitialAd` with the interstitial test ad unit ID.
   - Add frequency caps before production, for example: no more than one interstitial every 2-3 quizzes or every few minutes.
   - Show interstitials after quiz completion, never during answer selection.
   - Resolve the method gracefully if the ad fails to load so the result screen is not blocked.

7. **Replace `BannerAdPlaceholder`**
   - Convert `lib/widgets/banner_ad_placeholder.dart` into a stateful banner widget.
   - Create a `BannerAd` in `initState`, call `load()`, display it with `AdWidget`, and call `dispose()` in `dispose()`.
   - Keep a fallback placeholder/error state so layout remains stable if an ad fails to load.

8. **Add privacy and consent before production**
   - Add Google User Messaging Platform (UMP) consent flow if serving ads in regions that require consent.
   - Update the Play Console Data safety form for ad identifiers/analytics used by ads.
   - Add or update the privacy policy URL in the Play listing.

9. **Switch IDs safely**
   - Use test ad unit IDs in debug/dev builds.
   - Use production ad unit IDs only in release builds after AdMob review readiness.
   - Do not commit private account notes or unreviewed production IDs into public repositories.

10. **Test release behavior**
    - Run on a real Android device.
    - Verify rewarded callbacks grant exactly one reward per completed ad.
    - Verify interstitial failures never block quiz completion.
    - Verify banners do not overflow on small screens.

## Next features after MVP

- Real AdMob integration with consent/privacy flow.
- Better question packs and Nepali language mode.
- Category progress and streak rewards.
- Offline-first achievements.
- Real sharing with `share_plus`.
- Real leaderboard after choosing a backend.
- Firebase or custom backend only when multiplayer/login/leaderboard requirements are clear.
