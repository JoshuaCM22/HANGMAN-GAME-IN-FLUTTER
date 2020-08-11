import 'package:HANGMAN/screens/home_screen.dart';
import 'package:HANGMAN/utilities/clue_of_each_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:HANGMAN/components/action_button.dart';
import 'package:HANGMAN/utilities/hangman_words.dart';
import 'game_screen.dart';

class InstructionsScreen extends StatefulWidget {
  final HangmanWords hangmanWords = HangmanWords();
  final ClueOfEachWord clueOfEachWords = ClueOfEachWord();

  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    widget.hangmanWords.readWords();
    widget.clueOfEachWords.readWords();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 30, 8.0, 0),
              child: Text(
                'Instructions',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 43,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.012,
          ),
          Center(
            child: Container(
              width: 310,
              margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              padding: EdgeInsets.all(0),
              child: Text(
                'Guess each one word and you can tap the bulb to have a clue about the word. Avoid to do 6 mistakes to prevent decrease your heart life. When your heart life is 0, the game is over.',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontFamily: 'RobotoMono'),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.040,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Text(
                'Control',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 43,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.012,
          ),
          Center(
            child: Container(
              width: 310,
              margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              padding: EdgeInsets.all(0),
              child: Text(
                'Tap only.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontFamily: 'RobotoMono'),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.050,
          ),
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 35,
                    child: ActionButton(
                      buttonTitle: 'BACK',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.020,
          ),
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 35,
                    child: ActionButton(
                      buttonTitle: 'PLAY',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(
                              hangmanObject: widget.hangmanWords,
                              clueObject: widget.clueOfEachWords,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
