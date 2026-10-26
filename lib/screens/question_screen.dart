import 'package:flutter/material.dart';

import '../session/test_session.dart';
import '../theme.dart';
import '../widgets/option_tile.dart';
import '../widgets/question_card.dart';
import 'result_screen.dart';

/// One question per screen. Practice mode reveals the answer after each pick.
class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key, required this.session});

  final TestSession session;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _scroll = ScrollController();

  TestSession get s => widget.session;

  void _select(int option) => setState(() => s.select(option));

  void _next() {
    if (s.isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ResultScreen(session: s)),
      );
      return;
    }
    setState(s.next);
    _scroll.jumpTo(0);
  }

  OptionState _stateFor(int i) {
    final q = s.current;
    final picked = s.answerFor(q);
    if (picked == null) return OptionState.neutral;
    if (i == q.answer) return OptionState.correct;
    if (i == picked) return OptionState.wrong;
    return OptionState.faded;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = s.current;
    final picked = s.answerFor(q);
    final answered = picked != null;
    final modeLabel = s.mode == TestMode.practice ? 'Practice' : 'Exam';

    return Scaffold(
      appBar: AppBar(
        title: Text('Test ${s.bank.id} · $modeLabel'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(34),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                Text('${s.currentIndex + 1} / ${s.total}',
                    style: const TextStyle(
                        fontFamily: headingFont, color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (s.currentIndex + 1) / s.total,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(AppColors.yellow),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          QuestionCard(question: q, number: s.currentIndex + 1),
          const SizedBox(height: 16),
          for (var i = 0; i < q.options.length; i++)
            OptionTile(
              index: i,
              text: q.options[i],
              state: _stateFor(i),
              onTap: answered ? null : () => _select(i),
            ),
          if (answered) ...[
            const SizedBox(height: 6),
            ExplanationBox(
              correct: picked == q.answer,
              correctLabel: '${OptionTile.letter(q.answer)}. ${q.options[q.answer]}',
              explanation: q.explanation,
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: answered ? _next : null,
            child: Text(s.isLast ? 'See my score' : 'Next question'),
          ),
        ),
      ),
    );
  }
}
