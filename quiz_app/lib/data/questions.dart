class QuizQuestion {
  const QuizQuestion(this.text, this.answers);

  final String text;
  final List<String> answers;

  List<String> getShuffledAnswers() {
    final shuffledList = List<String>.of(answers);
    shuffledList.shuffle();
    return shuffledList;
  }
}

const questions = [
  QuizQuestion(
    'Ktorý programovací jazyk sa používa vo Flutteri?',
    [
      'Dart',
      'Java',
      'Python',
      'C++',
    ],
  ),
  QuizQuestion(
    'Ktorý widget umožňuje meniť stav aplikácie?',
    [
      'StatefulWidget',
      'StatelessWidget',
      'Text',
      'Icon',
    ],
  ),
  QuizQuestion(
    'Ktorá metóda aktualizuje stav widgetu?',
    [
      'setState()',
      'buildOnly()',
      'refreshPage()',
      'updateUI()',
    ],
  ),
  QuizQuestion(
    'Ktorý widget usporadúva prvky vertikálne?',
    [
      'Column',
      'Row',
      'Stack',
      'Expanded',
    ],
  ),
  QuizQuestion(
    'Čo robí metóda map() v jazyku Dart?',
    [
      'Transformuje prvky na nové hodnoty',
      'Vymaže celý zoznam',
      'Vráti počet prvkov',
      'Zoradí prvky podľa abecedy',
    ],
  ),
  QuizQuestion(
    'Ktorý widget umožňuje posúvať obsah?',
    [
      'SingleChildScrollView',
      'SizedBox',
      'Icon',
      'Center',
    ],
  ),
];