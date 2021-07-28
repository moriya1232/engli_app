import 'dart:async';

import 'package:engli_app/Data.dart';
import 'package:engli_app/srevices/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Registration extends StatefulWidget {
  final _error = StreamController<String>.broadcast();
  @override
  _RegistrationState createState() => _RegistrationState();
}


final nameControllerReg = TextEditingController();
final passwordControllerReg = TextEditingController();
final mailControllerReg = TextEditingController();

class _RegistrationState extends State<Registration> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    /*print("i clear");
    passwordControllerReg.clear();
    nameControllerReg.clear();
    mailControllerReg.clear();*/
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
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 10),
            child: Text(
              'הרשמה',
              style: TextStyle(
                fontFamily: 'Abraham-h',
                fontSize: 40,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(children: <Widget>[
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
              ButtonTheme(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  minWidth: 100,
                  buttonColor: Colors.black87,
                  child: SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
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
                                fontSize: 20)),
                      ))),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image(
              image: AssetImage('images/kids-read.jpg'),
            ),
          ),
        ]),
      ),
    );
  }

  void registerClicked(String email, String pass, String nameUser) async {
    if (nameUser.length == 0 ) {
      this.widget._error.add('הכנס שם');
      return;
    }
    if (pass.length < 6) {
      this.widget._error.add('הסיסמא צריכה להכיל לפחות 6 תווים');
      return;
    }
    dynamic res =
        await _auth.registerWithEmailAndPassword(email, pass, nameUser);
    if (res == null) {
      this.widget._error.add('אימייל או סיסמא שגויים');
      print("error mail");
      return;
    }
//    else {
//      //name = nameUser;
//      //mail = email;
//      Data().setName(nameUser);
//      Data().setMail(email);
//      print("good mail");
//    }
  }

  Widget getError() {
    return StreamBuilder<String>(
        stream: this.widget._error.stream,
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
    //TODO: but cant because after it it cant build again. when i register and exit and again register, the text field disposed yet.
//    nameController.dispose();
//    passwordController.dispose();
//    mailController.dispose();
    super.dispose();
  }
}
