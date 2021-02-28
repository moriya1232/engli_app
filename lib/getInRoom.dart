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
            SizedBox(height: 20),
            ButtonTheme(
                buttonColor: Colors.amberAccent,
                child: SizedBox(
                    height: 120,
                    width: 240,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        //                                Navigator.push(
                        //                                  context,
                        //                                  MaterialPageRoute(builder: (context) => Login()),
                        //                                );
                      },
                      child: Text(
                        'קוד למשחק קיים',
                        style: TextStyle(
                            fontFamily: 'Comix-h',
                            color: Colors.black87,
                            fontSize: 30),
                      ),
                    ))),
          ])),
    );
  }
}
