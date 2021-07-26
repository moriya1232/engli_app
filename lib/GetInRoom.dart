import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/Loading.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'OpenRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetInRoom extends StatefulWidget {
  String gameId;
  @override
  _GetInRoomState createState() => _GetInRoomState();
}

final gameIdController = TextEditingController();

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
                    controller: gameIdController,
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
                        getInToRoomClicked(gameIdController.text);
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
    String gameId = UniqueKey().toString();
    // print(gameId);
    await createGame(gameId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OpenRoom(gameId)),
    );
  }

  void getInToRoomClicked(String gameId) async {
    gameId = "[#" + gameId + "]";
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
    String name = "";
    if (user != null) {
      name = user.displayName;
    }
    await GameDatabaseService().addPlayer(gameId, name);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Loading(gameId, false)),
    );
  }

  Future<void> createGame(String gameId) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    List<int> cards = [];
    User user = _auth.currentUser;
    String name = user.displayName;
    if (user != null) {
      name = user.displayName;
    }
    await GameDatabaseService()
        .updateGame(false, null, 0, null, gameId, null, user.uid, false);
    await GameDatabaseService().addPlayer(gameId, name);
  }
}
