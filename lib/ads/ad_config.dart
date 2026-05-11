import 'package:flutter/foundation.dart';

/// Single switch for enabling real Google Mobile Ads SDK requests.
///
/// Keep this false by default so development, tests, and regular app builds do
/// not request ads unless a release owner deliberately changes the flag.
const bool useRealAds = false;

/// Ad unit IDs are intentionally Google's public test IDs only.
class AdConfig {
  const AdConfig._();

  static bool get isEnabled => useRealAds;

  static String get bannerAdUnitId => _forPlatform(
        android: 'ca-app-pub-3940256099942544/6300978111',
        ios: 'ca-app-pub-3940256099942544/2934735716',
      );

  static String get interstitialAdUnitId => _forPlatform(
        android: 'ca-app-pub-3940256099942544/1033173712',
        ios: 'ca-app-pub-3940256099942544/4411468910',
      );

  static String get rewardedAdUnitId => _forPlatform(
        android: 'ca-app-pub-3940256099942544/5224354917',
        ios: 'ca-app-pub-3940256099942544/1712485313',
      );

  static String _forPlatform({required String android, required String ios}) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    return android;
  }
}
