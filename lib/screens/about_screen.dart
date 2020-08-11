import 'package:HANGMAN/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:HANGMAN/components/action_button.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 30, 8.0, 0),
              child: Text(
                'About',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.0,
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
              height: 230,
              width: 240,
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 72.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/me.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.020,
          ),
          Center(
            child: Container(
              width: 310,
              margin: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              padding: EdgeInsets.all(0),
              child: Text(
                'Hi, I am Joshua C. Magoliman. The developer of this game.',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontFamily: 'RobotoMono'),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.040,
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
                  SizedBox(
                    height: 9,
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
