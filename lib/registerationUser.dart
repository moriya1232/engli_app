import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registertion extends StatefulWidget{
  @override
  _RegistarationState createState() => _RegistarationState();
}

class _RegistarationState extends State<Registertion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('הרשמה'),
        ),
        body:
            Center(
                child: Column (
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding (
                              padding: EdgeInsets.all(100),
                              child: Text(
                                'הרשמה',
                                style: TextStyle(
                                  fontFamily: 'Abraham-h',
                                  fontSize: 40,
                                ),
                              ),
                            ),
                          ]
                      ),
                      Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget> [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget> [
                                        new Flexible( child: TextField()),
                                        Text(':כתובת מייל '),
                                      ],
                                  ),
                                  Row(
                                    children: <Widget> [
                                      new Flexible( child: TextField()),
                                      Text(':שם '),
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
//                                        Navigator.push(
//                                          context,
//                                          MaterialPageRoute(builder: (context) => Registertion()),
//                                        );
                                            },
                                            child: Text(
                                                'הירשם',
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
                            ),


                          ]
                      ),
                      Expanded(
                        child: Align (
                          alignment: Alignment.bottomCenter,
                          child:
                          Image(
                            image: AssetImage('images/kids-read.jpg'),
                          ),
                        ),
                      ),

                    ]),
                )
            );
  }
}

