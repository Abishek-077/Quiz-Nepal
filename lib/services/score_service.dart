export '../features/quiz/data/repositories/local_quiz_stats_repository.dart';

import '../features/quiz/data/repositories/local_quiz_stats_repository.dart';
import 'storage_service.dart';

class ScoreService extends LocalQuizStatsRepository {
  ScoreService({StorageService? storageService})
      : super(dataSource: storageService);
}
