# Quiz-Nepal

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
