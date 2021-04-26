
import 'package:engli_app/registerationUser.dart';
import 'package:engli_app/srevices/auth.dart';
import 'package:flutter/material.dart';

import 'Data.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


//TODO: SHILO: change error according to the appropriate error.
String error = "";
final mailControllerLog = TextEditingController();
final passwordControllerLog = TextEditingController();

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    passwordControllerLog.clear();
    mailControllerLog.clear();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('התחברות'),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(70),
                    child: Text(
                      'התחברות',
                      style: TextStyle(
                        fontFamily: 'Abraham-h',
                        fontSize: 40,
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
                              controller: mailControllerLog,
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
                              controller: passwordControllerLog,
                            )),
                      ),
                      Text(':סיסמא '),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(error,
                  style: TextStyle(
                    color: Colors.red,
                  ),),
                  SizedBox(
                    height: 30,
                  ),
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
                                    fontSize: 20)),
                          ))),
                ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image(
              image: AssetImage('images/kids-read.jpg'),
            ),
          )
        ])));
  }

  void connectClicked() async {
    print(mailControllerLog.text);
    print(passwordControllerLog.text);
    dynamic res = await _auth.signInWithEmailAndPassword(
        mailControllerLog.text, passwordControllerLog.text);

    Data().setName(nameControllerReg.text); //TODO : get the name by the database
    Data().setMail(mailControllerLog.text);
    if (res == null) {
      setState(() => error = "could not sign in");
      print(error);
    }
  }

  @override
  void dispose() {
    //TODO: but cant because after it it cant build again. when i login and exit and again login, the text field disposed yet.
//    nameController.dispose();
//    passwordController.dispose();
    super.dispose();
  }
}
