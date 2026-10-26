import 'dart:convert';
import 'dart:io';

import 'package:drilldeck/models/question.dart';
import 'package:flutter_test/flutter_test.dart';

/// Structural quality checks for every bundled English test.
void main() {
  final files = Directory('assets/tests')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  test('test files exist', () {
    expect(files, isNotEmpty);
  });

  final seenIds = <String>{};
  final seenStems = <String, String>{};

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    group(name, () {
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final bank = TestBank.fromJson(json);

      test('file name matches test id', () {
        expect(name, 'test_${bank.id.toString().padLeft(2, '0')}.json');
      });

      test('has 40 questions and 50 minutes', () {
        expect(bank.questions, hasLength(40));
        expect(bank.durationMinutes, 50);
      });

      test('has the agreed type mix', () {
        int count(QuestionType t) => bank.questions.where((q) => q.type == t).length;
        expect(count(QuestionType.errorSpotting), 14);
        expect(count(QuestionType.sentenceCorrection), 13);
        expect(count(QuestionType.fillBlank), 13);
      });

      test('every question is well formed', () {
        for (final q in bank.questions) {
          final where = '${q.id} in $name';
          expect(q.id, startsWith('t${bank.id.toString().padLeft(2, '0')}q'), reason: where);
          expect(q.stem.trim(), isNotEmpty, reason: where);
          expect(q.explanation.trim().length, greaterThan(20), reason: where);
          expect(q.options, hasLength(5), reason: where);
          expect(q.options.every((o) => o.trim().isNotEmpty), isTrue, reason: where);
          expect(q.options.toSet(), hasLength(5), reason: '$where has duplicate options');
          expect(q.answer, inInclusiveRange(0, 4), reason: where);
          switch (q.type) {
            case QuestionType.errorSpotting:
              expect(q.options.last, 'No error', reason: where);
            case QuestionType.sentenceCorrection:
              expect(q.options.last, 'No correction required', reason: where);
              expect('**'.allMatches(q.stem), hasLength(2), reason: '$where needs one highlighted part');
            case QuestionType.fillBlank:
              expect(q.stem, contains('_____'), reason: where);
          }
        }
      });

      test('no duplicate ids or stems across tests', () {
        for (final q in bank.questions) {
          expect(seenIds.add(q.id), isTrue, reason: 'duplicate id ${q.id}');
          final key = q.stem.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
          expect(seenStems.containsKey(key), isFalse,
              reason: '${q.id} repeats the stem of ${seenStems[key]}');
          seenStems[key] = q.id;
        }
      });
    });
  }
}
