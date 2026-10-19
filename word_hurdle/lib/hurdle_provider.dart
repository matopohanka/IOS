import 'dart:math';
import 'package:flutter/material.dart';
import 'wordle.dart';

enum GameResult { incomplete, wrongWord, won, lost, gameOver }

class HurdleProvider extends ChangeNotifier {
  static const int wordLength = 5;
  static const int maxAttempts = 6;

  static const List<String> _words = [
    'APPLE', 'BREAD', 'CHAIR', 'DREAM', 'EARTH', 'FLAME', 'GRAPE', 'HOUSE',
    'LEMON', 'MOUSE', 'NIGHT', 'OCEAN', 'PLANT', 'RIVER', 'SMILE', 'TABLE',
    'WATER', 'YOUTH', 'ZEBRA', 'CLOUD', 'STONE', 'LIGHT', 'MUSIC', 'TIGER',
  ];

  final Random _random = Random();
  final List<Wordle> _board = List.generate(
    wordLength * maxAttempts,
    (_) => Wordle(),
  );
  final Map<String, LetterStatus> _keyStatus = {};

  late String _targetWord;
  int _row = 0; // aktuálny pokus
  int _col = 0; // aktuálne písmeno v riadku
  bool _gameOver = false;

  HurdleProvider() {
    reset();
  }

  List<Wordle> get board => _board;
  String get targetWord => _targetWord;
  bool get isGameOver => _gameOver;
  int get attemptsUsed => _row;
  LetterStatus keyStatus(String letter) =>
      _keyStatus[letter] ?? LetterStatus.initial;

  /// Reštart hry bez reštartu aplikácie.
  void reset() {
    _targetWord = _words[_random.nextInt(_words.length)];
    for (final cell in _board) {
      cell.clear();
    }
    _keyStatus.clear();
    _row = 0;
    _col = 0;
    _gameOver = false;
    notifyListeners();
  }

  /// Vloženie písmena z klávesnice.
  void _handleInput(String letter) {
    if (_gameOver || _col >= wordLength) return;
    _board[_row * wordLength + _col].letter = letter;
    _col++;
    notifyListeners();
  }

  void inputLetter(String letter) => _handleInput(letter.toUpperCase());

  void deleteLetter() {
    if (_gameOver || _col == 0) return;
    _col--;
    _board[_row * wordLength + _col].clear();
    notifyListeners();
  }

  /// Vyhodnotenie aktuálneho riadka (tlačidlo SUBMIT).
  GameResult checkAnswer() {
    if (_gameOver) return GameResult.gameOver;
    if (_col < wordLength) return GameResult.incomplete;

    final start = _row * wordLength;
    final guess = _board
        .sublist(start, start + wordLength)
        .map((w) => w.letter)
        .join();

    _evaluate(guess, start);

    if (guess == _targetWord) {
      _gameOver = true;
      notifyListeners();
      return GameResult.won;
    }

    _row++;
    _col = 0;

    if (_row >= maxAttempts) {
      _gameOver = true;
      notifyListeners();
      return GameResult.lost;
    }

    notifyListeners();
    return GameResult.wrongWord;
  }

  /// Dvojprechodové vyhodnotenie (správne ošetrí opakujúce sa písmená).
  void _evaluate(String guess, int start) {
    final statuses = List.filled(wordLength, LetterStatus.notInWord);
    final remaining = <String, int>{};

    // 1. prechod: správne pozície
    for (var i = 0; i < wordLength; i++) {
      if (guess[i] == _targetWord[i]) {
        statuses[i] = LetterStatus.correct;
      } else {
        remaining[_targetWord[i]] = (remaining[_targetWord[i]] ?? 0) + 1;
      }
    }
    // 2. prechod: písmená na nesprávnej pozícii
    for (var i = 0; i < wordLength; i++) {
      if (statuses[i] == LetterStatus.correct) continue;
      final count = remaining[guess[i]] ?? 0;
      if (count > 0) {
        statuses[i] = LetterStatus.inWord;
        remaining[guess[i]] = count - 1;
      }
    }

    for (var i = 0; i < wordLength; i++) {
      _board[start + i].status = statuses[i];
      final old = _keyStatus[guess[i]] ?? LetterStatus.initial;
      if (statuses[i].index > old.index) {
        _keyStatus[guess[i]] = statuses[i];
      }
    }
  }
}