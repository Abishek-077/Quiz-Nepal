export '../features/quiz/data/gateways/mock_ad_gateway.dart';

import '../features/quiz/data/gateways/mock_ad_gateway.dart';

class AdMobService extends MockAdGateway {
  AdMobService();

  static const rewardedTestAdUnitId = MockAdGateway.rewardedTestAdUnitId;
  static const interstitialTestAdUnitId =
      MockAdGateway.interstitialTestAdUnitId;
  static const bannerTestAdUnitId = MockAdGateway.bannerTestAdUnitId;
}
