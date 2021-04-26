import 'package:engli_app/srevices/auth.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

String error = '';

//TODO: dispose controllers in the end
final nameController = TextEditingController();
final passwordController = TextEditingController();
final mailController = TextEditingController();

class _RegistrationState extends State<Registration> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    passwordController.clear();
    nameController.clear();
    mailController.clear();
    return Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: new Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: mailController,
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
                          controller: passwordController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              //hintText: "הכנס כתובת מייל",
                              ),
                        )),
                  ),
                  Text(':סיסמא '),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: nameController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              //hintText: "הכנס שם",
                              ),
                        )),
                  ),
                  Text(':שם '),
                ],
              ),
              SizedBox(height: 40),
              Text(
                error,
                style: TextStyle(color: Colors.red),
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
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          primary: Colors.amberAccent,
                        ),
                        onPressed: () {
                          registerClicked(mailController.text,
                              passwordController.text, nameController.text);
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

  void registerClicked(email, pass, name) async {
    dynamic res = _auth.registerWithEmailAndPassword(email, pass, name);
    if (res == null) {
      setState(() => error = 'email is invaild');
      print("error mail");

      //TODO print this string to the screen
    } else {
      print("good mail");
    }
  }
}
