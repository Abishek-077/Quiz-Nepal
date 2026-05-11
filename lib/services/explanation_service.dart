import '../models/question_model.dart';
import 'admob_service.dart';

class ExplanationService {
  ExplanationService({AdMobService? adMobService})
      : _adMobService = adMobService ?? AdMobService();

  final AdMobService _adMobService;

  String shortExplanation(Question question) => question.shortExplanation;

  Future<String?> unlockFullExplanation(Question question) async {
    final unlocked = await _adMobService.showRewardedAd(
      placement: 'unlock_full_explanation',
    );
    return unlocked ? question.fullExplanation : null;
  }
}
