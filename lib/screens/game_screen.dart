import 'package:HANGMAN/utilities/clue_of_each_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:HANGMAN/screens/home_screen.dart';
import 'package:HANGMAN/utilities/alphabet.dart';
import 'package:HANGMAN/components/word_button.dart';
import 'package:HANGMAN/utilities/constants.dart';
import 'package:HANGMAN/utilities/hangman_words.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:HANGMAN/utilities/score_db.dart' as score_database;
import 'package:HANGMAN/utilities/user_scores.dart';

class GameScreen extends StatefulWidget {
  GameScreen({@required this.hangmanObject, @required this.clueObject});

  final HangmanWords hangmanObject;
  final ClueOfEachWord clueObject;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final database = score_database.openDB();
  int lives = 5;
  Alphabet englishAlphabet = Alphabet();
  String word;
  String clueOfWord;
  String hiddenWord;
  List<String> wordList = [];
  List<int> hintLetters = [];
  List<bool> buttonStatus;
  int hangState = 0;
  int wordCount = 0;
  bool finishedGame = false;
  bool resetGame = false;

  void newGame() {
    setState(() {
      widget.hangmanObject.resetWords();
      englishAlphabet = Alphabet();
      lives = 5;
      wordCount = 0;
      finishedGame = false;
      resetGame = false;
      initWords();
    });
  }

  Widget createButton(index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
      child: Center(
        child: WordButton(
          buttonTitle: englishAlphabet.alphabet[index].toUpperCase(),
          onPress: buttonStatus[index] ? () => wordPress(index) : null,
        ),
      ),
    );
  }

  void returnHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      ModalRoute.withName('homePage'),
    );
  }

  void initWords() {
    finishedGame = false;
    resetGame = false;
    hangState = 0;
    buttonStatus = List.generate(26, (index) {
      return true;
    });
    wordList = [];
    hintLetters = [];
    word = widget.hangmanObject.getWord();
    clueOfWord = widget.clueObject.getClue();

    print('THIS IS THE WORD: ' + word);
    print('THIS IS THE CLUE: ' + clueOfWord);
    if (word.length != 0) {
      hiddenWord = widget.hangmanObject.getHiddenWord(word.length);
    } else {
      Score score = Score(
          id: 1, scoreDate: DateTime.now().toString(), userScore: wordCount);
      score_database.manipulateDatabase(score, database);
      returnHomePage();
    }

    for (int i = 0; i < word.length; i++) {
      wordList.add(word[i]);
      hintLetters.add(i);
    }
    showSomeLetters();
  }

  void showSomeLetters() {
    for (int i = 1; i <= 2; i++) {
      int rand = Random().nextInt(hintLetters.length);
      wordPress(englishAlphabet.alphabet.indexOf(wordList[hintLetters[rand]]));
    }
  }

  void wordPress(int index) {
    if (finishedGame) {
      setState(() {
        resetGame = true;
      });
      return;
    }

    bool check = false;
    setState(() {
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i] == englishAlphabet.alphabet[index]) {
          check = true;
          wordList[i] = '';
          hiddenWord = hiddenWord.replaceFirst(RegExp('_'), word[i], i);
        }
      }
      for (int i = 0; i < wordList.length; i++) {
        if (wordList[i] == '') {
          hintLetters.remove(i);
        }
      }
      if (!check) {
        hangState += 1;
      }

      if (hangState == 6) {
        finishedGame = true;
        lives -= 1;
        if (lives == 0) {
          Alert(
              style: kGameOverAlertStyle,
              context: context,
              title: "Game Over!",
              desc: "Your score is $wordCount",
              buttons: [
                DialogButton(
                  width: 62,
                  onPressed: () {
                    if (wordCount != 0) {
                      Score score = Score(
                          id: 1,
                          scoreDate: DateTime.now().toString(),
                          userScore: wordCount);
                      score_database.manipulateDatabase(score, database);
                    }
                    returnHomePage();
                  },
                  child: Icon(
                    MdiIcons.home,
                    size: 30.0,
                  ),
                  color: kDialogButtonColor,
                ),
                DialogButton(
                  width: 62,
                  onPressed: () {
                    newGame();
                    Navigator.pop(context);
                  },
                  child: Icon(MdiIcons.refresh, size: 30.0),
                  color: kDialogButtonColor,
                ),
              ]).show();
        } else {
          Alert(
            context: context,
            style: kFailedAlertStyle,
            type: AlertType.error,
            title: word,
            buttons: [
              DialogButton(
                radius: BorderRadius.circular(10),
                child: Icon(
                  MdiIcons.arrowRightThick,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    initWords();
                  });
                },
                width: 127,
                color: kDialogButtonColor,
                height: 52,
              ),
            ],
          ).show();
        }
      }

      buttonStatus[index] = false;
      if (hiddenWord == word) {
        finishedGame = true;
        Alert(
          context: context,
          style: kSuccessAlertStyle,
          type: AlertType.success,
          title: word,
          buttons: [
            DialogButton(
              radius: BorderRadius.circular(10),
              child: Icon(
                MdiIcons.arrowRightThick,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  wordCount += 1;
                  Navigator.pop(context);
                  initWords();
                });
              },
              width: 127,
              color: kDialogButtonColor,
              height: 52,
            )
          ],
        ).show();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initWords();
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          "Clue",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
        ),
      ),
      content: Text(
        clueOfWord,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontFamily: 'RobotoMono',
        ),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (resetGame) {
      setState(() {
        initWords();
      });
    }
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 45.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 0.5),
                                      child: IconButton(
                                        tooltip: 'Lives',
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        iconSize: 39,
                                        icon: Icon(MdiIcons.heart),
                                        onPressed: () {},
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(8.7, 7.9, 0, 0.8),
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        height: 38,
                                        width: 38,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              lives.toString(),
                                              style: TextStyle(
                                                color: Color(0xFF2C1E68),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'PatrickHand',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              child: Text(
                                wordCount == 1
                                    ? "Score: 1"
                                    : 'Score: $wordCount',
                                style: kWordCounterTextStyle,
                              ),
                            ),
                            Container(
                              child: IconButton(
                                tooltip: 'Clue',
                                iconSize: 39,
                                icon: Icon(MdiIcons.lightbulb),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  showAlertDialog(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: FittedBox(
                            child: Image.asset(
                              'assets/images/$hangState.png',
                              height: 1001,
                              width: 991,
                              gaplessPlayback: true,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              hiddenWord,
                              style: kWordTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 10.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: createButton(0),
                      ),
                      TableCell(
                        child: createButton(1),
                      ),
                      TableCell(
                        child: createButton(2),
                      ),
                      TableCell(
                        child: createButton(3),
                      ),
                      TableCell(
                        child: createButton(4),
                      ),
                      TableCell(
                        child: createButton(5),
                      ),
                      TableCell(
                        child: createButton(6),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(7),
                      ),
                      TableCell(
                        child: createButton(8),
                      ),
                      TableCell(
                        child: createButton(9),
                      ),
                      TableCell(
                        child: createButton(10),
                      ),
                      TableCell(
                        child: createButton(11),
                      ),
                      TableCell(
                        child: createButton(12),
                      ),
                      TableCell(
                        child: createButton(13),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(14),
                      ),
                      TableCell(
                        child: createButton(15),
                      ),
                      TableCell(
                        child: createButton(16),
                      ),
                      TableCell(
                        child: createButton(17),
                      ),
                      TableCell(
                        child: createButton(18),
                      ),
                      TableCell(
                        child: createButton(19),
                      ),
                      TableCell(
                        child: createButton(20),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(21),
                      ),
                      TableCell(
                        child: createButton(22),
                      ),
                      TableCell(
                        child: createButton(23),
                      ),
                      TableCell(
                        child: createButton(24),
                      ),
                      TableCell(
                        child: createButton(25),
                      ),
                      TableCell(
                        child: Text(''),
                      ),
                      TableCell(
                        child: Text(''),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
