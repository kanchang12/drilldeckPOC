import '../models/question.dart';

enum TestMode { exam, practice }

/// The live state of one attempt at a test. Lives in memory only.
class TestSession {
  TestSession({required this.bank, required this.mode});

  final TestBank bank;
  final TestMode mode;

  /// Question id -> chosen option index.
  final Map<String, int> answers = {};
  int currentIndex = 0;

  List<Question> get questions => bank.questions;
  int get total => questions.length;
  Question get current => questions[currentIndex];
  bool get isLast => currentIndex == total - 1;

  int? answerFor(Question q) => answers[q.id];
  bool isAnswered(Question q) => answers.containsKey(q.id);

  void select(int option) {
    // Practice mode locks the first answer so the explanation can't be gamed.
    if (mode == TestMode.practice && isAnswered(current)) return;
    answers[current.id] = option;
  }

  void next() {
    if (!isLast) currentIndex++;
  }

  int get correctCount => questions.where((q) => answers[q.id] == q.answer).length;

  /// Whole-number percentage of the full test; unanswered questions count as not correct.
  int get scorePercent => total == 0 ? 0 : (correctCount * 100 / total).round();
}
