import 'package:flutter/material.dart';

import '../theme.dart';

enum OptionState { neutral, selected, correct, wrong, faded }

/// Full-width A–E answer tile.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.state,
    this.onTap,
  });

  final int index;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  static String letter(int index) => String.fromCharCode(65 + index);

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color border, Color badgeBg, Color badgeFg) = switch (state) {
      OptionState.neutral => (AppColors.card, AppColors.border, AppColors.background, AppColors.blue),
      OptionState.selected => (const Color(0xFFE8F0FD), AppColors.blue, AppColors.blue, Colors.white),
      OptionState.correct => (const Color(0xFFE6F6EE), AppColors.correct, AppColors.correct, Colors.white),
      OptionState.wrong => (const Color(0xFFFCEBEA), AppColors.wrong, AppColors.wrong, Colors.white),
      OptionState.faded => (AppColors.card, AppColors.border, AppColors.background, AppColors.muted),
    };
    final trailing = switch (state) {
      OptionState.correct => const Icon(Icons.check_circle_rounded, color: AppColors.correct),
      OptionState.wrong => const Icon(Icons.cancel_rounded, color: AppColors.wrong),
      _ => null,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: state == OptionState.neutral ? 1 : 2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
                  child: Text(letter(index),
                      style: TextStyle(
                          fontFamily: headingFont, fontWeight: FontWeight.w600, color: badgeFg)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(text,
                      style: TextStyle(
                          fontSize: 16.5,
                          height: 1.35,
                          color: state == OptionState.faded ? AppColors.muted : AppColors.navy)),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
