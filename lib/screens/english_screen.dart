import 'package:flutter/material.dart';

import '../services/question_bank.dart';
import '../session/test_session.dart';
import '../theme.dart';
import '../widgets/mode_sheet.dart';
import 'question_screen.dart';

class EnglishScreen extends StatefulWidget {
  const EnglishScreen({super.key});

  @override
  State<EnglishScreen> createState() => _EnglishScreenState();
}

class _EnglishScreenState extends State<EnglishScreen> {
  // Results aren't saved yet, so New test always starts Test 1.
  final int _nextTestId = 1;

  Future<void> _startNewTest() async {
    final mode = await showModeSheet(context, testId: _nextTestId);
    if (mode == null || !mounted) return;
    try {
      final bank = await QuestionBank.load(_nextTestId);
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => QuestionScreen(session: TestSession(bank: bank, mode: mode)),
      ));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("This test couldn't be loaded. Please try another one.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('English')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Grammar error spotting, sentence correction and fill in the blanks. '
              'Bank-exam pattern: 40 questions in 50 minutes.',
              style: text.bodyMedium?.copyWith(color: AppColors.muted)),
          const SizedBox(height: 20),
          _ActionCard(
            title: 'New test',
            subtitle: 'Test $_nextTestId of ${QuestionBank.testCount}',
            icon: Icons.play_arrow_rounded,
            highlight: true,
            onTap: _startNewTest,
          ),
          const SizedBox(height: 14),
          _ActionCard(
            title: 'Completed',
            subtitle: 'No tests completed yet',
            icon: Icons.check_circle_rounded,
            highlight: false,
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.highlight,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: cardDecoration(color: highlight ? AppColors.blue : AppColors.card),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: highlight ? AppColors.yellow : AppColors.background,
                child: Icon(icon, size: 32, color: highlight ? AppColors.navy : AppColors.blue),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontFamily: headingFont,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: highlight ? Colors.white : AppColors.navy)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 15,
                            color: highlight ? Colors.white.withValues(alpha: 0.9) : AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
