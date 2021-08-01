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

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).size.width / 2);
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

          Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      '!ברוכים הבאים',
                      style: TextStyle(
                        fontFamily: 'Abraham-h',
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IncDecAnimationWidget(
                                  Image.asset('images/A.jpg'), 100, 120),
                              IncDecAnimationWidget(Image.asset('images/F.jpg'), 80, 80),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 70,
                                  width: 210,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(22.0)),
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
                                width: 210,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20.0)),
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
                                          borderRadius:
                                          BorderRadius.circular(20.0)),
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
                      ),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IncDecAnimationWidget(Image.asset('images/R.jpg'), 70, 70),
                              IncDecAnimationWidget(Image.asset('images/W.jpg'), 80, 80),
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
  IncDecAnimationWidget(Image image, double height, double width) : this._image = image, this._height = height, this._width = width;
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