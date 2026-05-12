import 'package:flutter/services.dart';

class AssetQuestionDataSource {
  AssetQuestionDataSource({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<String> loadQuestionJson(String assetPath) =>
      _bundle.loadString(assetPath);
}
