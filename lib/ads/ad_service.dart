import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';
import 'ad_placements.dart';

/// Centralized AdMob integration.
///
/// Placement rules are enforced by the public method names and accepted enums:
/// - Interstitials are only exposed through
///   [showInterstitialAfterQuizResultScreenOpens].
/// - Rewarded ads are only exposed through [showRewardedForUserAction].
/// - Banners are implemented in the `AdMobBanner` widget for home/category use.
class AdService {
  AdService._();

  static final AdService instance = AdService._();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInitialized = false;
  bool _isLoadingInterstitial = false;
  bool _isLoadingRewarded = false;

  Future<void> initialize() async {
    if (!AdConfig.isEnabled || _isInitialized) {
      return;
    }

    await MobileAds.instance.initialize();
    _isInitialized = true;
    loadInterstitial();
    loadRewarded();
  }

  void loadInterstitial() {
    if (!AdConfig.isEnabled ||
        _isLoadingInterstitial ||
        _interstitialAd != null) {
      return;
    }

    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingInterstitial = false;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _isLoadingInterstitial = false;
          debugPrint('Interstitial failed to load: $error');
        },
      ),
    );
  }

  /// Shows an interstitial only after the quiz result screen has opened.
  ///
  /// Do not call this from question screens; no public API here supports that
  /// placement, which prevents surprise interstitials during quiz questions.
  bool showInterstitialAfterQuizResultScreenOpens({
    InterstitialAdPlacement placement =
        InterstitialAdPlacement.quizResultScreenOpened,
    VoidCallback? onDismissed,
    VoidCallback? onUnavailable,
  }) {
    if (!AdConfig.isEnabled ||
        placement != InterstitialAdPlacement.quizResultScreenOpened) {
      onUnavailable?.call();
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      onUnavailable?.call();
      loadInterstitial();
      return false;
    }

    _interstitialAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onDismissed?.call();
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint('Interstitial failed to show: $error');
        onUnavailable?.call();
        loadInterstitial();
      },
    );
    ad.show();
    return true;
  }

  void loadRewarded() {
    if (!AdConfig.isEnabled || _isLoadingRewarded || _rewardedAd != null) {
      return;
    }

    _isLoadingRewarded = true;
    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingRewarded = false;
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          _isLoadingRewarded = false;
          debugPrint('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  /// Shows a rewarded ad only in direct response to an allowed user action.
  bool showRewardedForUserAction({
    required RewardedAdTrigger trigger,
    required OnUserEarnedRewardCallback onUserEarnedReward,
    VoidCallback? onDismissed,
    VoidCallback? onUnavailable,
  }) {
    if (!AdConfig.isEnabled) {
      onUnavailable?.call();
      return false;
    }

    final ad = _rewardedAd;
    if (ad == null) {
      onUnavailable?.call();
      loadRewarded();
      return false;
    }

    _rewardedAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onDismissed?.call();
        loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint('Rewarded ad failed to show for $trigger: $error');
        onUnavailable?.call();
        loadRewarded();
      },
    );
    ad.show(onUserEarnedReward: onUserEarnedReward);
    return true;
  }

  Future<void> dispose() async {
    await _interstitialAd?.dispose();
    await _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }
}
