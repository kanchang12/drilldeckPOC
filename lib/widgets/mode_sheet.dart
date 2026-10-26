import 'package:flutter/material.dart';

import '../session/test_session.dart';
import '../theme.dart';

/// Asks Exam or Practice before a test starts. Returns null if dismissed.
Future<TestMode?> showModeSheet(BuildContext context, {required int testId}) {
  return showModalBottomSheet<TestMode>(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('English Test $testId', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('How do you want to take it?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted)),
            const SizedBox(height: 16),
            _ModeOption(
              icon: Icons.timer_rounded,
              title: 'Exam mode',
              subtitle: '40 questions · 50 minutes · answers at the end',
              enabled: false,
              badge: 'Next update',
              onTap: () => Navigator.pop(context, TestMode.exam),
            ),
            const SizedBox(height: 12),
            _ModeOption(
              icon: Icons.school_rounded,
              title: 'Practice mode',
              subtitle: 'Untimed · see the answer and explanation after each question',
              enabled: true,
              onTap: () => Navigator.pop(context, TestMode.practice),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Ink(
            decoration: cardDecoration(),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(icon, color: AppColors.blue, size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(title, style: Theme.of(context).textTheme.titleMedium),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: AppColors.yellow, borderRadius: BorderRadius.circular(8)),
                            child: Text(badge!,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
