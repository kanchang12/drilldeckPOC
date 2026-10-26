import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/question.dart';

/// Loads the English tests bundled in assets/tests/. Read-only; never touches the network.
class QuestionBank {
  static const testCount = 10;

  static String assetPath(int testId) => 'assets/tests/test_${testId.toString().padLeft(2, '0')}.json';

  static Future<TestBank> load(int testId, {AssetBundle? bundle}) async {
    final raw = await (bundle ?? rootBundle).loadString(assetPath(testId));
    return TestBank.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
