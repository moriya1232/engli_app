import 'dart:async';
import 'package:engli_app/srevices/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final nameControllerReg = TextEditingController();
  final passwordControllerReg = TextEditingController();
  final mailControllerReg = TextEditingController();
  final _error = StreamController<String>.broadcast();
  final AuthService _auth = AuthService();
  bool _firstClickRegister = true;
  double widthScreen;
  double heightScreen;

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('הרשמה'),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(heightScreen / 10),
            child: Text(
              'הרשמה',
              style: TextStyle(
                fontFamily: 'Abraham-h',
                fontSize: widthScreen/12,
              ),
            ),
          ),
          Column(children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: nameControllerReg,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          //hintText: "הכנס שם",
                        ),
                        inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")), LengthLimitingTextInputFormatter(10)],
                      )),
                ),
                Text(':שם '),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: mailControllerReg,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            //hintText: "הכנס כתובת מייל",
                            ),
                      )),
                ),
                Text(':כתובת מייל '),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordControllerReg,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            //hintText: "הכנס כתובת מייל",
                            ),
                          inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[a-z0-9A-Z]")), LengthLimitingTextInputFormatter(10)],
                      )),
                ),
                Text(':סיסמא '),
              ],
            ),
            SizedBox(height: 20),
            getError(),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0)),
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                primary: Colors.amberAccent,
              ),
              onPressed: () {
                registerClicked(
                    mailControllerReg.text,
                    passwordControllerReg.text,
                    nameControllerReg.text);
              },
              child: Text('הירשם',
                  style: TextStyle(
                      fontFamily: 'Comix-h',
                      color: Colors.black87,
                      fontSize: widthScreen/22)),
            ),
            SizedBox(height: 20),
            Image(
                image: AssetImage('images/kids-read.jpg'),),
          ]),
        ]),
      ),
    );
  }

  void registerClicked(String email, String pass, String nameUser) async {
    if (nameUser.length == 0 ) {
      this._error.add('הכנס שם');
      return;
    } else if (pass.length < 6) {
      this._error.add('הסיסמא צריכה להכיל לפחות 6 תווים');
      return;
    } else if (!_firstClickRegister) {return;}
    _firstClickRegister = false;
    dynamic res =
        await _auth.registerWithEmailAndPassword(email, pass, nameUser);
    if (res == null) {
      this._error.add('אימייל או סיסמא לא תקינים');
      _firstClickRegister = true;
      return;
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
    this.mailControllerReg.dispose();
    this.nameControllerReg.dispose();
    this.passwordControllerReg.dispose();
    super.dispose();
  }
}
