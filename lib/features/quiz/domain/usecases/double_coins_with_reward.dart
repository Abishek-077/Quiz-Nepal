import '../repositories/ad_gateway.dart';
import '../repositories/quiz_stats_repository.dart';

class DoubleCoinsWithReward {
  const DoubleCoinsWithReward(this._adGateway, this._statsRepository);

  final AdGateway _adGateway;
  final QuizStatsRepository _statsRepository;

  Future<bool> call(int coinsEarned) async {
    final rewarded =
        await _adGateway.showRewardedAd(placement: 'double_result_coins');
    if (rewarded) {
      await _statsRepository.addCoins(coinsEarned);
    }
    return rewarded;
  }
}
