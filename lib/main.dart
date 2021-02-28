import 'package:flutter/material.dart';
import 'loginUser.dart';
import 'registerationUser.dart';

void main() => runApp(EngliApp());

class EngliApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engli - לימוד אנגלית',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('engLI - לימוד אנגלית'),
        centerTitle: true,
        shadowColor: Colors.black87,
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
                        '!ברוכים הבאים',
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
                        buttonColor: Colors.black87,
                        child: SizedBox(
                            height: 80,
                            width: 220,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              color: Colors.amberAccent,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Registertion()),
                                );
                              },
                              child: Text('הרשמה',
                                  style: TextStyle(
                                      fontFamily: 'Comix-h',
                                      color: Colors.black87,
                                      fontSize: 30)),
                            ))),

//                        ButtonTheme(
//                            minWidth: 150,
//                            buttonColor: Colors.black87,
//                            child: RaisedButton(
//                              onPressed: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => registertionStore()),
//                                );
//                              },
//                              child: Text(
//                                  'Create Store Account',
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                  )
//                              ),
//                            )
//                        ),
                    SizedBox(height: 20),
                    ButtonTheme(
                        buttonColor: Colors.amberAccent,
                        child: SizedBox(
                            height: 80,
                            width: 220,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                );
                              },
                              child: Text(
                                'התחברות',
                                style: TextStyle(
                                    fontFamily: 'Comix-h',
                                    color: Colors.black87,
                                    fontSize: 30),
                              ),
                            ))),
                  ]),
            ])),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Image(
              image: AssetImage('images/kids-read.jpg'),
            ),
          ),
        )
      ])),
    );
  }
}
