import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LoginUser.dart';
import 'RegisterationUser.dart';
import 'package:engli_app/srevices/auth.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).size.width / 2);
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
  final AuthService _auth = AuthService();
  double widthScreen;
  double heightScreen;

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('engLI - לימוד אנגלית'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: ListView(
        shrinkWrap: false,
        padding: EdgeInsets.zero,
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: heightScreen / 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: heightScreen / 25),
              child: Text(
                '!ברוכים הבאים',
                style: TextStyle(
                  fontFamily: 'Abraham-h',
                  fontSize: widthScreen / 12,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: heightScreen / 25),
              child: Row(children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IncDecAnimationWidget(Image.asset('images/A.jpg'),
                        heightScreen / 8, widthScreen / 4),
                    IncDecAnimationWidget(Image.asset('images/F.jpg'),
                        heightScreen / 10, widthScreen / 6),
                  ],
                )),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 35),
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
                                  fontSize: widthScreen / 12)),
                        ),
                        SizedBox(height: heightScreen / 48),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 35),
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
                                fontSize: widthScreen / 15),
                          ),
                        ),
                        SizedBox(height: heightScreen / 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
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
                                fontSize: widthScreen / 25),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IncDecAnimationWidget(Image.asset('images/R.jpg'),
                        heightScreen / 10, widthScreen / 5),
                    IncDecAnimationWidget(Image.asset('images/W.jpg'),
                        heightScreen / 9, widthScreen / 5),
                  ],
                )),
              ]),
            ),
          ]),
//          Align(
//            alignment: Alignment.bottomCenter,
//            child:
          Image(
            image: AssetImage('images/kids-read.jpg'),
//            ),
          ),
        ],
      ),
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

  void loginGuestClicked() async {
    dynamic result = await _auth.signInAnon();
    if (result == null) {
      print("Error in sign annon");
    } else {
      print("sign in annon");
    }
  }
}

class IncDecAnimationWidget extends StatefulWidget {
  final Image _image;
  final double _height;
  final double _width;
  IncDecAnimationWidget(Image image, double height, double width)
      : this._image = image,
        this._height = height,
        this._width = width;
  @override
  _IncDecAnimationWidgetState createState() => _IncDecAnimationWidgetState();
}

class _IncDecAnimationWidgetState extends State<IncDecAnimationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: this._controller,
      builder: (context, child) {
        return Container(
            height: widget._height,
            width: widget._width,
            child: Padding(
                padding: EdgeInsets.all(
                    widget._height / 10 + this._controller.value * 10),
                child: widget._image));
      },
    );
  }
}
