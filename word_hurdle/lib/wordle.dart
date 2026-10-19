/// Stav jedného písmena. Poradie je dôležité (vyššia hodnota = vyššia priorita).
enum LetterStatus { initial, notInWord, inWord, correct }

/// Model jedného políčka v tabuľke.
class Wordle {
  String letter;
  LetterStatus status;

  Wordle({this.letter = '', this.status = LetterStatus.initial});

  bool get isEmpty => letter.isEmpty;

  void clear() {
    letter = '';
    status = LetterStatus.initial;
  }
}