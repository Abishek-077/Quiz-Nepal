import '../repositories/ad_gateway.dart';
import '../services/quiz_engine.dart';

class ContinueQuizWithReward {
  const ContinueQuizWithReward(this._adGateway);

  final AdGateway _adGateway;

  Future<bool> call(QuizEngine engine) async {
    final rewarded =
        await _adGateway.showRewardedAd(placement: 'continue_after_hearts');
    if (rewarded) {
      engine.restoreHearts(QuizEngine.rewardedContinueHearts);
    }
    return rewarded;
  }
}
