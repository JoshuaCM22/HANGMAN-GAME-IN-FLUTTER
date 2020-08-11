import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:HANGMAN/components/action_button.dart';
import 'package:flutter/services.dart';
import 'about_screen.dart';
import 'instructions_screen.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    showAlertDialog(BuildContext context) {
      Widget noButton = FlatButton(
        child: Text(
          "No",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget yesButton = FlatButton(
        child: Text(
          "Yes",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        onPressed: () {
          SystemNavigator.pop();
        },
      );

      AlertDialog alert = AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Attention",
            style: TextStyle(
                color: Colors.black, fontSize: 28.0, fontFamily: 'RobotoMono'),
          ),
        ),
        content: Text(
          "Are you sure you want to exit?",
          style: TextStyle(
              color: Colors.black, fontSize: 19.0, fontFamily: 'RobotoMono'),
        ),
        actions: [
          yesButton,
          noButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 30, 8.0, 0),
              child: Text(
                'Hangman',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 58.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 300,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.010,
          ),
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 35,
                    child: ActionButton(
                      buttonTitle: 'START',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstructionsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    height: 35,
                    child: ActionButton(
                      buttonTitle: 'HIGH SCORES',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    height: 35,
                    child: ActionButton(
                      buttonTitle: 'ABOUT',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Container(
                    height: 35,
                    child: ActionButton(
                      buttonTitle: 'EXIT',
                      onPress: () {
                        showAlertDialog(context);
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
