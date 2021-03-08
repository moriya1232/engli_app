import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'openRoom.dart';

class GetInRoom extends StatefulWidget {
  @override
  _getInRoomState createState() => _getInRoomState();
}

class _getInRoomState extends State<GetInRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('כניסה לחדר'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            ButtonTheme(
                buttonColor: Colors.black87,
                child: SizedBox(
                    height: 120,
                    width: 240,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      color: Colors.amberAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OpenRoom()),
                        );
                      },
                      child: Text('פתיחת חדר',
                          style: TextStyle(
                              fontFamily: 'Comix-h',
                              color: Colors.black87,
                              fontSize: 30)),
                    ))),
            SizedBox(height: 80),
            new Container(
                height: 80,
                width: 240,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(20))),
                      labelText: "הכנס קוד משחק",

                      //hintText: "הכנס קוד משחק",
                    ),
                  ),
                  //controller: nameController,
                )),
            ButtonTheme(
                buttonColor: Colors.black87,
                child: SizedBox(
                    height: 40,
                    width: 100,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      color: Colors.pink,
                      onPressed: () {},
                      child: Text('כנס לחדר',
                          style: TextStyle(
                              fontFamily: 'Comix-h',
                              color: Colors.black87,
                              fontSize: 15)),
                    ))),
//            ButtonTheme(
//                buttonColor: Colors.amberAccent,
//                child: SizedBox(
//                    height: 120,
//                    width: 240,
//                    child: RaisedButton(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(20.0)),
//                      onPressed: () {
//
//                      },
//                      child: Text(
//                        'קוד למשחק קיים',
//                        style: TextStyle(
//                            fontFamily: 'Comix-h',
//                            color: Colors.black87,
//                            fontSize: 30),
//                      ),
//                    ))),
          ])),
    );
  }
}
