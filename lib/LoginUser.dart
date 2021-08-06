import 'dart:async';

import 'package:engli_app/srevices/auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _mailControllerLog = TextEditingController();
  final _passwordControllerLog = TextEditingController();
  final _error = StreamController<String>.broadcast();
  final AuthService _auth = AuthService();
  bool _firstClickRegister = true;

  @override
  Widget build(BuildContext context) {
    _passwordControllerLog.clear();
    _mailControllerLog.clear();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('התחברות'),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height/10),
                  child: Text(
                    'התחברות',
                    style: TextStyle(
                      fontFamily: 'Abraham-h',
                      fontSize: MediaQuery.of(context).size.width/12,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
//                          border: OutlineInputBorder(
//                            borderRadius: const BorderRadius.all(const Radius.circular(20))
//                          ),
//                        hintText: "הכנס כתובת מייל",
                                ),
                            controller: _mailControllerLog,
                          )),
                    ),
                    Text(':כתובת מייל '),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: new Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            obscureText: true,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
//                          border: OutlineInputBorder(
//                            borderRadius: const BorderRadius.all(const Radius.circular(20))
//                          ),
//                        hintText: "הכנס כתובת מייל",
                                ),
                            controller: _passwordControllerLog,
                          )),
                    ),
                    Text(':סיסמא '),
                  ],
                ),
                SizedBox(height: 30),
                getError(),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    padding:
                        const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    primary: Colors.amberAccent,
                  ),
                  onPressed: () {
                    connectClicked();
                  },
                  child: Text('התחבר',
                      style: TextStyle(
                          fontFamily: 'Comix-h',
                          color: Colors.black87,
                          fontSize: MediaQuery.of(context).size.width/22)),
                ),
                SizedBox(height: 20,),
                Image(
                  image: AssetImage('images/kids-read.jpg'),
                )
              ]),
        ));
  }

  void connectClicked() async {
    if (!_firstClickRegister) {return;}
    _firstClickRegister = false;
    dynamic res = await _auth.signInWithEmailAndPassword(
        _mailControllerLog.text, _passwordControllerLog.text);
    if (res == null) {
      _firstClickRegister = true;
      this._error.add("אימייל או סיסמא שגויים");
    }
  }

  Widget getError() {
    return StreamBuilder<String>(
        stream: this._error.stream,
        initialData: "",
        builder: (context, snapshot) {
          return Text(
            snapshot.data,
            style: TextStyle(
              fontFamily: 'Trashim-h',
              fontSize: 15,
              color: Colors.red,
            ),
          );
        });
  }

  @override
  void dispose() {
    this._error.close();
    this._mailControllerLog.dispose();
    this._passwordControllerLog.dispose();
    super.dispose();
  }
}
