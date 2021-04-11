import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('הרשמה'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(100),
                    child: Text(
                      'הרשמה',
                      style: TextStyle(
                        fontFamily: 'Abraham-h',
                        fontSize: 40,
                      ),
                    ),
                  ),
                ]),
            Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(child:
                          new Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  //hintText: "הכנס כתובת מייל",
                                ),
                              )
                          ),
                          ),
                          Text(':כתובת מייל '),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child:
                          new Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  //hintText: "הכנס שם",
                                ),
                              )
                          ),
                          ),
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
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0)),
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                primary: Colors.amberAccent,
                                ),
                                onPressed: () {
                                  registerClicked();
                                },
                                child: Text('הירשם',
                                    style: TextStyle(
                                        fontFamily: 'Comix-h',
                                        color: Colors.black87,
                                        fontSize: 20)),
                              ))),
                    ]),
                  ),
                ]),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: AssetImage('images/kids-read.jpg'),
                ),
              ),
            ),
          ]),
        ));
  }

  void registerClicked() {
    //TODO

  }
}
