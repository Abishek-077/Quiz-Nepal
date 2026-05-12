abstract class AdGateway {
  Future<bool> showRewardedAd({String placement = 'rewarded'});

  Future<bool> showInterstitialAd({String placement = 'quiz_complete'});
}
