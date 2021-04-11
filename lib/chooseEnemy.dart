import 'package:engli_app/MemoryRoom.dart';
import 'package:flutter/material.dart';

class ChooseEnemy extends StatefulWidget {
  @override
  _ChooseEnemyState createState() => _ChooseEnemyState();
}

class _ChooseEnemyState extends State<ChooseEnemy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('בחירת משחק'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    buttonColor: Colors.black87,
                    child: SizedBox(
                        height: 140,
                        width: 330,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0)),
                          primary: Colors.amberAccent,
                          ),
                          onPressed: () {
                            playAgainstComputerClicked();
                          },
                          child: Text('שחק נגד המחשב',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Comix-h',
                                  color: Colors.black87,
                                  fontSize: 50)),
                        ))),
                SizedBox(height: 20),
                ButtonTheme(
                    buttonColor: Colors.amberAccent,
                    child: SizedBox(
                        height: 140,
                        width: 330,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                            primary: Colors.amberAccent,
                          ),
                          onPressed: () {
                            playAgainstOtherPlayerClicked();
                          },
                          child: Text(
                            'שחק נגד יריב אחר',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Comix-h',
                                color: Colors.black87,
                                fontSize: 50),
                          ),
                        ))),
              ]),
        ),
      ),
    );
  }

  void playAgainstComputerClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MemoryRoom(true)),
    );
  }

  void playAgainstOtherPlayerClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MemoryRoom(false)),
    );
  }
}
