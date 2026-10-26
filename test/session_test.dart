import 'package:drilldeck/models/question.dart';
import 'package:drilldeck/session/test_session.dart';
import 'package:flutter_test/flutter_test.dart';

TestBank fakeBank(int n) => TestBank(
      id: 1,
      title: 'English Test 1',
      durationMinutes: 50,
      questions: [
        for (var i = 0; i < n; i++)
          Question(
            id: 'q$i',
            type: QuestionType.fillBlank,
            stem: 'Stem _____ $i',
            options: const ['a', 'b', 'c', 'd', 'e'],
            answer: 1,
            explanation: 'Because b.',
          ),
      ],
    );

void main() {
  group('practice mode', () {
    test('scores correct answers as a whole percentage', () {
      final s = TestSession(bank: fakeBank(40), mode: TestMode.practice);
      for (var i = 0; i < 40; i++) {
        s.select(i < 29 ? 1 : 0);
        s.next();
      }
      expect(s.correctCount, 29);
      expect(s.scorePercent, 73); // 72.5 rounds up
    });

    test('locks the first answer', () {
      final s = TestSession(bank: fakeBank(3), mode: TestMode.practice);
      s.select(0);
      s.select(1);
      expect(s.answerFor(s.current), 0);
    });

    test('unanswered questions count as not correct', () {
      final s = TestSession(bank: fakeBank(4), mode: TestMode.practice);
      s.select(1);
      expect(s.scorePercent, 25);
    });

    test('next stops at the last question', () {
      final s = TestSession(bank: fakeBank(2), mode: TestMode.practice);
      s.next();
      s.next();
      expect(s.currentIndex, 1);
      expect(s.isLast, isTrue);
    });
  });
}
