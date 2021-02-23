import 'package:engli_app/chooseGame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('התחברות'),
        ),
        body:
            Center(
                child: Column (
                    children: <Widget>[
                SingleChildScrollView(
                child: Column(
                    children: <Widget> [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding (
                              padding: EdgeInsets.all(100),
                              child: Text(
                                'התחברות',
                                style: TextStyle(
                                  fontFamily: 'Abraham-h',
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ]
                      ),
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: <Widget> [
                                new Flexible( child: TextField()),
                                Text(':כתובת מייל '),
                              ],
                            ),
                            SizedBox(height: 60),
                            ButtonTheme(
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                minWidth: 100,
                                buttonColor: Colors.black87,
                                child: SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(22.0)),
                                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      color: Colors.amberAccent,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ChooseGame()),
                                        );
                                      },
                                      child: Text(
                                          'התחבר',
                                          style: TextStyle(
                                              fontFamily: 'Comix-h',
                                              color: Colors.black87,
                                              fontSize: 20
                                          )
                                      ),
                                    )
                                )
                            ),
                          ]),
            ])
            ),
                Expanded(
                    child: Align (
                      alignment: Alignment.bottomCenter,
                      child:
                      Image(
                        image: AssetImage('images/kids-read.jpg'),
                      ),
                    ),

                )
    ]
            )
        )
    );
  }
}

