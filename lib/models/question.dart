enum QuestionType {
  errorSpotting('error_spotting', 'Error Spotting',
      'Find the part of the sentence that has an error. If there is no error, choose "No error".'),
  sentenceCorrection('sentence_correction', 'Sentence Correction',
      'Which option should replace the highlighted part to make the sentence correct? If no change is needed, choose "No correction required".'),
  fillBlank('fill_blank', 'Fill in the Blank', 'Choose the word that best fills the blank.');

  const QuestionType(this.key, this.label, this.instruction);

  final String key;
  final String label;
  final String instruction;

  static QuestionType fromKey(String key) =>
      values.firstWhere((t) => t.key == key, orElse: () => throw FormatException('Unknown question type: $key'));
}

class Question {
  const Question({
    required this.id,
    required this.type,
    required this.stem,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  final String id;
  final QuestionType type;

  /// Sentence correction stems mark the highlighted part with **double asterisks**.
  final String stem;
  final List<String> options;
  final int answer;
  final String explanation;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        type: QuestionType.fromKey(json['type'] as String),
        stem: json['stem'] as String,
        options: List<String>.from(json['options'] as List),
        answer: json['answer'] as int,
        explanation: json['explanation'] as String,
      );
}

class TestBank {
  const TestBank({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.questions,
  });

  final int id;
  final String title;
  final int durationMinutes;
  final List<Question> questions;

  factory TestBank.fromJson(Map<String, dynamic> json) => TestBank(
        id: json['id'] as int,
        title: json['title'] as String,
        durationMinutes: json['durationMinutes'] as int,
        questions: (json['questions'] as List)
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}
