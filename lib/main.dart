import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'registerationUser.dart';


void main() => runApp(EngliApp());

class EngliApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Engli - לימוד אנגלית',
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
        body:
        Center(
            child:
                  Column (
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding (
                          padding: EdgeInsets.all(60),
                          child: Text(
                            '!ברוכים הבאים',
                            style: TextStyle(
                              //fontFamily: 'Hebrew',
                              fontSize: 40,
                            ),
                          ),
                        ),
                  ButtonTheme(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            minWidth: 180,
                            buttonColor: Colors.black87,

                            child: SizedBox(
                                height: 80,
                                width: 220,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22.0)),
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              color: Colors.amberAccent,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Registertion()),
                                );
                              },
                              child: Text(
                                  'הרשמה',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 30
                                  )
                              ),
                            )
                        )
                        ),

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
                            minWidth: 150,
                            buttonColor: Colors.amberAccent,
                                child: SizedBox(
                                  height: 80,
                                    width: 220,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      ),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              onPressed: () {},
                              child: Text(
                                'התחברות',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 30
                                ),
                              ),
                            )
                            )
                            )
                      ]),
        )
    );
  }
}

