import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'OpenRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetInRoom extends StatefulWidget {
  @override
  _GetInRoomState createState() => _GetInRoomState();
}

class _GetInRoomState extends State<GetInRoom> {
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        primary: Colors.amberAccent,
                      ),
                      onPressed: () {
                        openRoomClicked();
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        primary: Colors.pink,
                      ),
                      onPressed: () {
                        getInToRoomClicked();
                      },
                      child: Text('כנס לחדר',
                          style: TextStyle(
                              fontFamily: 'Comix-h',
                              color: Colors.black87,
                              fontSize: 15)),
                    ))),
          ])),
    );
  }

  void openRoomClicked() async {
    await createGame();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OpenRoom()),
    );
  }

  void getInToRoomClicked() {
    //TODO
  }
  Future<void> createGame() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String gameId = UniqueKey().toString();
    List<int> cards = [];
    String name = _auth.currentUser.displayName.toString();
    await GameDatabaseService().updateGame(false, null, 0, null, gameId);
    await FirebaseFirestore.instance
        .collection("games")
        .doc(gameId)
        .collection("players")
        .add({
      'cards': cards,
      'name': name,
      'score': 0,
    });
  }
}
