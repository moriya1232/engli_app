import 'dart:async';
import 'package:engli_app/EditingVocabulary.dart';
import 'package:engli_app/QuartetsInstructions.dart';
import 'package:engli_app/srevices/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'GetInRoom.dart';
import 'MemoryInstructions.dart';
import 'OpenMemoryRoom.dart';

class ChooseGame extends StatefulWidget {
  @override
  _ChooseGameState createState() => _ChooseGameState();
}

class _ChooseGameState extends State<ChooseGame> {
  final _userName = StreamController<String>.broadcast();
  AuthService _auth = AuthService();
  @override
  void initState() {
    _auth.user.listen((event) {
      if (event != null && event.displayName != null) {
        this._userName.add(event.displayName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('בחירת משחק'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      print("instructions");
                      instructionsClicked();
                    },
                    child: Text('הוראות',
                        style: TextStyle(
                            fontFamily: 'Comix-h',
                            color: Colors.teal,
                            fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
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
              ]),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 20),
                child: getUserName(),
              ),
              SingleChildScrollView(
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
      ),
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
      MaterialPageRoute(builder: (context) => OpenMemoryRoom()),
    );
  }

  void instructionsClicked() {
    _showMaterialDialog();
  }

  Widget getUserName() {
    return StreamBuilder<String>(
        stream: this._userName.stream,
        initialData: "",
        builder: (context, snapshot) {
          return Text(
            'Hello ' + snapshot.data,
            style: TextStyle(
              fontFamily: 'AkayaK-e',
              fontSize: 40,
            ),
          );
        });
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(
                "איזה משחק?",
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              content: new Wrap(
                textDirection: TextDirection.rtl,
                alignment: WrapAlignment.center,
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        quartetsInsructionsClicked();
                      },
                      child: Text('- רביעיות',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontFamily: 'Abraham-h',
                              color: Colors.teal,
                              fontSize: 30)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        memoryInstructionsClicked();
                      },
                      child: Text('- משחק זיכרון',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontFamily: 'Abraham-h',
                              color: Colors.teal,
                              fontSize: 30)),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('סגור', textDirection: TextDirection.rtl),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  void editVocabularyClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new EditingVocabulary()),
    );
  }

  void memoryInstructionsClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new MemoryInstructions()),
    );
  }

  void quartetsInsructionsClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new QuartetsInstructions()),
    );
  }

  void logoutClicked() async {
    await _auth.signOut();
  }
}
