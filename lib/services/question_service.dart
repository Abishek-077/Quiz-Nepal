export '../features/quiz/data/repositories/asset_question_repository.dart';

import 'package:flutter/services.dart';

import '../features/quiz/data/datasources/asset_question_data_source.dart';
import '../features/quiz/data/repositories/asset_question_repository.dart';

class QuestionService extends AssetQuestionRepository {
  QuestionService({AssetBundle? bundle, super.random})
      : super(
          dataSource: AssetQuestionDataSource(bundle: bundle),
        );
}
