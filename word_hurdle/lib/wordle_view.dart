import 'package:flutter/material.dart';
import 'wordle.dart';

Color statusColor(LetterStatus status) => switch (status) {
      LetterStatus.correct => Colors.green,
      LetterStatus.inWord => Colors.orange.shade700,
      LetterStatus.notInWord => Colors.grey.shade800,
      LetterStatus.initial => Colors.transparent,
    };

class WordleView extends StatelessWidget {
  final Wordle wordle;
  const WordleView({super.key, required this.wordle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: statusColor(wordle.status),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: wordle.isEmpty ? Colors.white24 : Colors.white70,
          width: 1.5,
        ),
      ),
      child: Text(
        wordle.letter,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}