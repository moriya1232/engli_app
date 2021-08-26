import 'dart:async';

import 'package:engli_app/Loading.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'OpenRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetInRoom extends StatefulWidget {
  @override
  _GetInRoomState createState() => _GetInRoomState();
}

class _GetInRoomState extends State<GetInRoom> {
  final _gameIdController = TextEditingController();
  final _error = StreamController<String>.broadcast();
  bool firstClick = true;

  @override
  void dispose() {
    this._gameIdController.dispose();
    this._error.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.firstClick = true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('כניסה לחדר'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(30),
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
                        fontSize: MediaQuery.of(context).size.width/13)),
              ),
              SizedBox(height: 80),
              Container(
                  height: 80,
                  width: 240,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: _gameIdController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(20))),
                        labelText: "הכנס קוד משחק",
                        labelStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/30,
                        )

                        //hintText: "הכנס קוד משחק",
                      ),
                    ),
                    //controller: nameController,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getError(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0)),
                  primary: Colors.pink,
                ),
                onPressed: () {
                  getInToRoomClicked(_gameIdController.text);
                },
                child: Text('כנס לחדר',
                    style: TextStyle(
                        fontFamily: 'Comix-h',
                        color: Colors.black87,
                        fontSize: MediaQuery.of(context).size.width/25)),
              ),
            ]),
      )),
    );
  }

  void openRoomClicked() async {
    if (firstClick) {
      this.firstClick = false;
      var uuid = Uuid();
      String gameId = uuid.v1().substring(0,5);
      try {
        await createGame(gameId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OpenRoom(gameId)),
      );
      this.firstClick = true;
      } catch (e){
        print("ERROR openRoonCLicked $e");
      }
    }
  }

  void getInToRoomClicked(String gameId) async {
    gameId = "[#" + gameId + "]";
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
    String name = "";
    if (user != null) {
      name = user.displayName;
    }
    // 1- if success
    // 2- if too much players.
    // 3 - if no exist this code.
    int succ = await GameDatabaseService().addPlayerToDataBase(gameId, name, user.uid);

    if (succ == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Loading(gameId, false)),
      );
    } else if (succ == 2) {
      this._error.add("לא יכול להתחבר, יש יותר מדי שחקנים");
    } else if (succ == 3) {
      this._error.add("קוד משחק לא נכון");
    }
  }

  Future<void> createGame(String gameId) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
    return GameDatabaseService()
        .updateGame(false, null, 0, null, gameId, null, user.uid, false);
//    await GameDatabaseService().addPlayer(gameId, name);
  }

  Widget getError() {
    return StreamBuilder<String>(
        stream: this._error.stream,
        initialData: "",
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? "",
            style: TextStyle(
              fontFamily: 'Trashim-h',
              fontSize: 15,
              color: Colors.red,
            ),
          );
        });
  }
}
