import 'package:engli_app/quartetsRoom.dart';
import 'package:flutter/material.dart';

class OpenRoom extends StatefulWidget {
  @override
  _openRoomState createState() => _openRoomState();
}

class _openRoomState extends State<OpenRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('בחירת משחק'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Container(
          child: Column(children: <Widget>[
        Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[]),
            ])),
        Expanded(
          child: Align(

            alignment: Alignment.bottomCenter,

            child: Padding(

              padding: EdgeInsets.all(40),

              child: ButtonTheme(

                  padding: EdgeInsets.all(20),

                  buttonColor: Colors.pink,

                  child: SizedBox(

                      child: RaisedButton(

                    shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(20.0)),

                    onPressed: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(builder: (context) => QuartetsRoom()),

                      );

                    },

                    child: Text(

                      '!התחל משחק',

                      style: TextStyle(

                          fontFamily: 'Comix-h',

                          color: Colors.black87,

                          fontSize: 20),

                    ),

                  ))),

            ),

          ),
        )
      ])),
    );
  }
}
