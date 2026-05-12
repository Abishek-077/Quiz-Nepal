import '../entities/question.dart';
import '../repositories/ad_gateway.dart';

class UnlockFullExplanation {
  const UnlockFullExplanation(this._adGateway);

  final AdGateway _adGateway;

  Future<String?> call(Question question) async {
    final unlocked =
        await _adGateway.showRewardedAd(placement: 'unlock_full_explanation');
    return unlocked ? question.fullExplanation : null;
  }
}
