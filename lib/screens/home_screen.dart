import 'package:flutter/material.dart';

import '../theme.dart';
import 'english_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _comingSoon = [
    ('Quantitative Aptitude', Icons.calculate_rounded),
    ('Reasoning', Icons.extension_rounded),
    ('Maths', Icons.functions_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            const _Wordmark(),
            const SizedBox(height: 6),
            Text('Practise anywhere. No internet needed.',
                style: text.bodyMedium?.copyWith(color: AppColors.muted)),
            const SizedBox(height: 28),
            Text('Subjects', style: text.titleLarge),
            const SizedBox(height: 12),
            _SubjectCard(
              title: 'English',
              subtitle: '10 tests · 40 questions each',
              icon: Icons.menu_book_rounded,
              active: true,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const EnglishScreen())),
            ),
            for (final (title, icon) in _comingSoon)
              _SubjectCard(
                title: title,
                subtitle: 'Coming soon',
                icon: icon,
                active: false,
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('$title is coming soon.')));
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontFamily: headingFont, fontSize: 34, fontWeight: FontWeight.w700);
    return Text.rich(
      const TextSpan(children: [
        TextSpan(text: 'Drill', style: TextStyle(color: AppColors.blue)),
        TextSpan(text: 'Deck', style: TextStyle(color: Color(0xFFE0A800))),
      ]),
      style: style,
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = active ? Colors.white : AppColors.navy;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Ink(
            decoration: cardDecoration(color: active ? AppColors.blue : AppColors.card),
            padding: EdgeInsets.all(active ? 22 : 18),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: active ? AppColors.yellow : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: active ? AppColors.navy : AppColors.muted),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontFamily: headingFont,
                              fontSize: active ? 20 : 17,
                              fontWeight: FontWeight.w600,
                              color: active ? fg : AppColors.navy.withValues(alpha: 0.7))),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 14,
                              color: active ? Colors.white.withValues(alpha: 0.85) : AppColors.muted)),
                    ],
                  ),
                ),
                Icon(active ? Icons.arrow_forward_rounded : Icons.lock_clock_rounded,
                    color: active ? Colors.white : AppColors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
