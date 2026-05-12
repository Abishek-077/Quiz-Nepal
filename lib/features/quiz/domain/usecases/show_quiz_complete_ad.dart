import '../repositories/ad_gateway.dart';

class ShowQuizCompleteAd {
  const ShowQuizCompleteAd(this._adGateway);

  final AdGateway _adGateway;

  Future<bool> call() =>
      _adGateway.showInterstitialAd(placement: 'quiz_complete');
}
