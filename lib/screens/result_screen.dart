import 'package:flutter/material.dart';

import '../session/test_session.dart';
import '../theme.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.session});

  final TestSession session;

  String get _message {
    final p = session.scorePercent;
    if (p >= 80) return 'Excellent work!';
    if (p >= 60) return 'Nice work — keep going!';
    if (p >= 40) return 'Good effort. Review and try the next one.';
    return 'Every test makes you sharper. Keep practising!';
  }

  @override
  Widget build(BuildContext context) {
    final s = session;
    final modeLabel = s.mode == TestMode.practice ? 'Practice' : 'Exam';
    return Scaffold(
      appBar: AppBar(title: Text('${s.bank.title} · $modeLabel'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: double.infinity,
                decoration: cardDecoration(),
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                child: Column(
                  children: [
                    const Text('Your score',
                        style: TextStyle(fontFamily: headingFont, fontSize: 16, color: AppColors.muted)),
                    const SizedBox(height: 8),
                    Container(
                      width: 170,
                      height: 170,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.blue,
                        border: Border.all(color: AppColors.yellow, width: 8),
                      ),
                      child: Text('${s.scorePercent}%',
                          style: const TextStyle(
                              fontFamily: headingFont,
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                    const SizedBox(height: 18),
                    Text('${s.correctCount} of ${s.total} correct',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(_message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted)),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to English'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
