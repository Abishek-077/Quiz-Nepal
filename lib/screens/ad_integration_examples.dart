import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ads/ad_placements.dart';
import '../ads/ad_service.dart';
import '../widgets/admob_banner.dart';

/// Example home page placement: banner only.
class HomePageAdSlot extends StatelessWidget {
  const HomePageAdSlot({super.key});

  @override
  Widget build(BuildContext context) => const AdMobBanner.home();
}

/// Example category page placement: banner only.
class CategoryPageAdSlot extends StatelessWidget {
  const CategoryPageAdSlot({super.key});

  @override
  Widget build(BuildContext context) => const AdMobBanner.category();
}

/// Call from the quiz result screen after the first frame has rendered.
void showResultInterstitialAfterScreenOpens() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AdService.instance.showInterstitialAfterQuizResultScreenOpens();
  });
}

/// Rewarded ad examples. Wire these to explicit button taps only.
void unlockFullExplanationWithRewardedAd({
  required OnUserEarnedRewardCallback onRewardEarned,
  VoidCallback? onUnavailable,
}) {
  AdService.instance.showRewardedForUserAction(
    trigger: RewardedAdTrigger.unlockFullExplanation,
    onUserEarnedReward: onRewardEarned,
    onUnavailable: onUnavailable,
  );
}

void continueQuizWithRewardedAd({
  required OnUserEarnedRewardCallback onRewardEarned,
  VoidCallback? onUnavailable,
}) {
  AdService.instance.showRewardedForUserAction(
    trigger: RewardedAdTrigger.continueQuiz,
    onUserEarnedReward: onRewardEarned,
    onUnavailable: onUnavailable,
  );
}

void doubleCoinsWithRewardedAd({
  required OnUserEarnedRewardCallback onRewardEarned,
  VoidCallback? onUnavailable,
}) {
  AdService.instance.showRewardedForUserAction(
    trigger: RewardedAdTrigger.doubleCoins,
    onUserEarnedReward: onRewardEarned,
    onUnavailable: onUnavailable,
  );
}
