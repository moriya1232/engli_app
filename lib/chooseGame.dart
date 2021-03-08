import 'package:engli_app/MemoryRoom.dart';
import 'package:engli_app/editingVocabulary.dart';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'getInRoom.dart';

class ChooseGame extends StatefulWidget {
  @override
  _ChooseGameState createState() => _ChooseGameState();
}

class _ChooseGameState extends State<ChooseGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('בחירת משחק'),
        centerTitle: true,
      ),
      body: Container(
          child: Column(children: <Widget>[
        Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(100),
                      child: Text(
                        '!שלום ${Data().getName()}',
                        style: TextStyle(
                          fontFamily: 'Abraham-h',
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ]),
              Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        buttonColor: Colors.black87,
                        child: SizedBox(
                            height: 140,
                            width: 330,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.amberAccent,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GetInRoom()),
                                );
                              },
                              child: Text('רביעיות',
                                  style: TextStyle(
                                      fontFamily: 'Comix-h',
                                      color: Colors.black87,
                                      fontSize: 50)),
                            ))),
                    SizedBox(height: 20),
                    ButtonTheme(
                        buttonColor: Colors.amberAccent,
                        child: SizedBox(
                            height: 140,
                            width: 330,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MemoryRoom()),
                                );
                              },
                              child: Text(
                                'זיכרון',
                                style: TextStyle(
                                    fontFamily: 'Comix-h',
                                    color: Colors.black87,
                                    fontSize: 50),
                              ),
                            ))),
                  ]),
            ])),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(40),
              child: ButtonTheme(
                  padding: EdgeInsets.all(20),
                  buttonColor: Colors.pink,
                  child: SizedBox(
                      child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => new EditingVocabulaty()),
                            );
                    },
                    child: Text(
                      'עריכת אוצר מילים',
                      style: TextStyle(
                          fontFamily: 'Comix-h',
                          color: Colors.black87,
                          fontSize: 20),
                    ),
                  ))),
            ),
          ),
        )
      ])),
    );
  }
}
