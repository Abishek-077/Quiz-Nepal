class AdMobService {
  static const rewardedTestAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const interstitialTestAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const bannerTestAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  Future<bool> showRewardedAd({String placement = 'rewarded'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return true;
  }

  Future<bool> showInterstitialAd({String placement = 'quiz_complete'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return true;
  }
}
