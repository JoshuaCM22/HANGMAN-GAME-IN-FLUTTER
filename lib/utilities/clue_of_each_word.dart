import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class ClueOfEachWord {
  int wordCounter = 0;
  List<int> _usedNumbers = [];
  List<String> _clues = [];
  static int numberFromHangmanClass;

  Future readWords() async {
    String fileText =
        await rootBundle.loadString('assets/words/clue_of_each_word.txt');
    _clues = fileText.split('\n');
  }

  void resetWords() {
    wordCounter = 0;
    _usedNumbers = [];
  }

  void getTheNumberFromHangmanClass(int x) {
    numberFromHangmanClass = x;
  }

  // ignore: missing_return
  String getClue() {
    wordCounter += 1;
    var rand = Random();
    int clueLength = _clues.length;

    bool notUnique = true;
    if (wordCounter - 1 == _clues.length) {
      notUnique = false;
      return '';
    }
    while (notUnique) {
      if (!_usedNumbers.contains(numberFromHangmanClass)) {
        notUnique = false;
        _usedNumbers.add(numberFromHangmanClass);
        return _clues[numberFromHangmanClass];
      } else {
        numberFromHangmanClass = rand.nextInt(clueLength);
      }
    }
  }
}
