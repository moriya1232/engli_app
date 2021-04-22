import 'package:engli_app/chooseEnemy.dart';
import 'package:engli_app/editingVocabulary.dart';
import 'package:engli_app/srevices/auth.dart';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'getInRoom.dart';

class ChooseGame extends StatefulWidget {
  @override
  _ChooseGameState createState() => _ChooseGameState();
}

class _ChooseGameState extends State<ChooseGame> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('בחירת משחק'),
        centerTitle: true,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: GestureDetector(
//                  style: ElevatedButton.styleFrom(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(22.0)),
//                      primary: Colors.amberAccent),
                  onTap: () {
                    logoutClicked();
                  },
                  child: Text('התנתק',
                      style: TextStyle(
                          fontFamily: 'Comix-h',
                          color: Colors.teal,
                          fontSize: 20)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
              child: Text(
                '!שלום ${Data().getName()}',
                style: TextStyle(
                  fontFamily: 'Abraham-h',
                  fontSize: 40,
                ),
              ),
            ),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  SizedBox(
                      height: 140,
                      width: 330,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0)),
                          primary: Colors.amberAccent,
                        ),
                        onPressed: () {
                          quartetsClicked();
                        },
                        child: Text('רביעיות',
                            style: TextStyle(
                                fontFamily: 'Comix-h',
                                color: Colors.black87,
                                fontSize: 50)),
                      )),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 140,
                    width: 330,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          primary: Colors.amberAccent),
                      onPressed: () {
                        memoryClicked();
                      },
                      child: Text(
                        'זיכרון',
                        style: TextStyle(
                            fontFamily: 'Comix-h',
                            color: Colors.black87,
                            fontSize: 50),
                      ),
                    ),
                  ),
                ])),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      primary: Colors.pink),
                  onPressed: () {
                    editVocabularyClicked();
                  },
                  child: Text(
                    'עריכת אוצר מילים',
                    style: TextStyle(
                        fontFamily: 'Comix-h',
                        color: Colors.black87,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  void quartetsClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GetInRoom()),
    );
  }

  void memoryClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseEnemy()),
    );
  }

  void editVocabularyClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new EditingVocabulaty()),
    );
  }

  void logoutClicked() async {
    await _auth.signOut();
  }
}
