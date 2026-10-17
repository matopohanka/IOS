
import 'package:flutter/material.dart';

import 'data/questions.dart';
import 'questions_summary.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
  });

  final List<String> chosenAnswers;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final summary = QuestionsSummary(
      chosenAnswers: chosenAnswers,
    ).getSummaryData();

    final numTotalQuestions = questions.length;

    final numCorrectQuestions = summary.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Správne si odpovedal na '
            '$numCorrectQuestions z $numTotalQuestions otázok!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: QuestionsSummary(
                chosenAnswers: chosenAnswers,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }
}
