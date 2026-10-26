import 'package:flutter/material.dart';

import '../models/question.dart';
import '../theme.dart';

/// The question itself: type label, instruction, and the stem.
class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key, required this.question, required this.number});

  final Question question;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: cardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Q$number',
                  style: const TextStyle(
                      fontFamily: headingFont, fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.blue)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(20)),
                child: Text(question.type.label,
                    style: const TextStyle(
                        fontFamily: headingFont, fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(question.type.instruction,
              style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.muted)),
          const SizedBox(height: 14),
          Text.rich(stemSpan(question.stem), style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// Renders **marked** text as the highlighted part of a sentence correction question.
TextSpan stemSpan(String stem) {
  final parts = stem.split('**');
  return TextSpan(children: [
    for (var i = 0; i < parts.length; i++)
      if (parts[i].isNotEmpty)
        TextSpan(
          text: parts[i],
          style: i.isOdd
              ? const TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.blue,
                  decorationThickness: 2,
                  backgroundColor: Color(0x55FFD43B),
                )
              : null,
        ),
  ]);
}

/// Answer explanation box shown in practice mode and in review.
class ExplanationBox extends StatelessWidget {
  const ExplanationBox({super.key, required this.correct, required this.correctLabel, required this.explanation});

  final bool? correct;
  final String correctLabel;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final (String heading, Color color) = switch (correct) {
      true => ('Correct!', AppColors.correct),
      false => ('Not quite', AppColors.wrong),
      null => ('Not answered', AppColors.muted),
    };
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: TextStyle(fontFamily: headingFont, fontWeight: FontWeight.w700, fontSize: 17, color: color)),
          const SizedBox(height: 4),
          Text('Answer: $correctLabel',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.navy)),
          const SizedBox(height: 8),
          Text(explanation, style: const TextStyle(fontSize: 15.5, height: 1.45, color: AppColors.navy)),
        ],
      ),
    );
  }
}
