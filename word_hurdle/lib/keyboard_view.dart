import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hurdle_provider.dart';
import 'wordle.dart';
import 'wordle_view.dart';

class KeyboardView extends StatelessWidget {
  final VoidCallback onSubmit;
  const KeyboardView({super.key, required this.onSubmit});

  static const _rows = ['QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HurdleProvider>();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in _rows)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final letter in row.split(''))
                  _key(
                    label: letter,
                    color: provider.keyStatus(letter) == LetterStatus.initial
                        ? Colors.blueGrey.shade700
                        : statusColor(provider.keyStatus(letter)),
                    onTap: () => provider.inputLetter(letter),
                  ),
              ],
            ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: provider.deleteLetter,
                child: const Text('DELETE'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: onSubmit,
                child: const Text('SUBMIT'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _key({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: SizedBox(
            width: 32,
            height: 44,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}