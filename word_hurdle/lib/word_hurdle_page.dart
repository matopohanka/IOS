
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helper_functions.dart';
import 'hurdle_provider.dart';
import 'keyboard_view.dart';
import 'wordle_view.dart';

class WordHurdlePage extends StatelessWidget {
  const WordHurdlePage({super.key});

  void _submit(BuildContext context) {
    final provider = context.read<HurdleProvider>();
    final result = provider.checkAnswer();

    switch (result) {
      case GameResult.incomplete:
        showMsg(
          context,
          'Enter all ${HurdleProvider.wordLength} letters.',
        );
        break;

      case GameResult.wrongWord:
        showMsg(context, 'Not the word. Try again!');
        break;

      case GameResult.won:
        showResult(
          context: context,
          title: 'You won! 🎉',
          body: 'The word was ${provider.targetWord}.\n'
              'Attempts used: ${provider.attemptsUsed}.',
          onPlayAgain: provider.reset,
          onCancel: () {},
        );
        break;

      case GameResult.lost:
        showResult(
          context: context,
          title: 'You lost 😞',
          body: 'The word was ${provider.targetWord}.',
          onPlayAgain: provider.reset,
          onCancel: () {},
        );
        break;

      case GameResult.gameOver:
        showMsg(context, 'Game over. Press restart to play again.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HurdleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hurdle'),
        actions: [
          IconButton(
            tooltip: 'Restart',
            onPressed: provider.reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;

            // Priestor pre klávesnicu a ovládacie tlačidlá.
            final keyboardHeight = availableHeight * 0.38;

            final boardHeight =
                availableHeight - keyboardHeight - 16;

            return Column(
              children: [
                SizedBox(
                  height: boardHeight,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio:
                          HurdleProvider.wordLength / 
                          HurdleProvider.maxAttempts,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: provider.board.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                HurdleProvider.wordLength,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            return WordleView(
                              wordle: provider.board[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: keyboardHeight,
                  child: KeyboardView(
                    onSubmit: () => _submit(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
