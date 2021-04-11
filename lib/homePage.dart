import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loginUser.dart';
import 'registerationUser.dart';

class FirstScreen extends StatelessWidget {
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //TODO : animated letters.
                  AnimationWidget(),
                  AnimationWidget(),
//                  AnimatedContainer(
//                      child: Image.asset('images/A.jpg'),
//                      duration: Duration(seconds: 1)),
//                  AnimatedContainer(
//                      child: Image.asset('images/R.jpg'),
//                      duration: Duration(seconds: 1)),
//                  AnimatedContainer(
//                      child: Image.asset('images/F.jpg'),
//                      duration: Duration(seconds: 1)),
//                  AnimatedContainer(
//                      child: Image.asset('images/W.jpg'),
//                      duration: Duration(seconds: 1)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '!ברוכים הבאים',
                    style: TextStyle(
                      fontFamily: 'Abraham-h',
                      fontSize: 40,
                    ),
                  ),
                  Column(children: [
                    SizedBox(
                        height: 70,
                        width: 220,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0)),
                            primary: Colors.amberAccent,
                          ),
                          onPressed: () {
                            registerationClicked();
                          },
                          child: Text('הרשמה',
                              style: TextStyle(
                                  fontFamily: 'Comix-h',
                                  color: Colors.black87,
                                  fontSize: 30)),
                        )),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 70,
                      width: 220,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            primary: Colors.amberAccent),
                        onPressed: () {
                          loginClicked();
                        },
                        child: Text(
                          'התחברות',
                          style: TextStyle(
                              fontFamily: 'Comix-h',
                              color: Colors.black87,
                              fontSize: 30),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            primary: Colors.amberAccent),
                        onPressed: () {
                          loginGuestClicked();
                        },
                        child: Text(
                          'התחבר כאורח',
                          style: TextStyle(
                              fontFamily: 'Comix-h',
                              color: Colors.black87,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image(
                      image: AssetImage('images/kids-read.jpg'),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  void registerationClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
  }

  void loginClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void loginGuestClicked() {
    //TODO
  }
}

class AnimationWidget extends StatefulWidget {
  @override
  _AnimationWidgetState createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Image.asset('images/A.jpg');
  }
}
