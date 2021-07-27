import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/QuartetsRoom.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cards/Subject.dart';

class Loading extends StatefulWidget {
  bool isBoss;
  List<Player> usersLogin;
  String gameId;
  // List<Subject> subjects;
  // Map<CardQuartets, int> cardsId = {};

  Loading(String gameId, bool isBoss) {
    this.usersLogin = [];
    this.isBoss = isBoss;
    this.gameId = gameId;
    // this.subjects = subs;
    // this.cardsId = cardsId;
  }

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final _usersLoginStreamController =
      StreamController<List<String>>.broadcast();
  StreamSubscription<DocumentSnapshot> _eventsSubscription = null;

  @override
  void initState() {
    _eventsSubscription = FirebaseFirestore.instance
        .collection("games")
        .doc(this.widget.gameId)
        .snapshots()
        .listen((event) {
      List<dynamic> names = event.data()['players'];
      names = names.cast<String>();
      this._usersLoginStreamController.add(names);

      if (event.data()['continueToGame'] == true) {
        _eventsSubscription.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuartetsRoom(this.widget.usersLogin,
                  this.widget.gameId, widget.isBoss, false)),
        );
      }
    });
    //listen
    super.initState();
    //_eventsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
//        title: Text('מחכה לשחקנים נוספים...'),
//        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ':קוד משחק',
                    style: TextStyle(fontSize: 30, fontFamily: 'Comix-h'),
                  ),
                  Text(
                    cleanGameId(this.widget.gameId),
                    style: TextStyle(
                      fontSize: 60,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    ':שחקנים מחוברים',
                    style: TextStyle(fontSize: 30, fontFamily: 'Comix-h'),
                  ),
                  getListNameUsers(),
                  SizedBox(
                    height: 30,
                  ),
                  //getUserLogin(),
                  SizedBox(
                    height: 30,
                  ),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 50,
                  ),
                  if (widget.isBoss)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        primary: Colors.amberAccent,
                      ),
                      onPressed: () {
                        continueToGameClicked();
                      },
                      child: Text('המשך למשחק',
                          style: TextStyle(
                              fontFamily: 'Comix-h',
                              color: Colors.black87,
                              fontSize: 20)),
                    )
                ]),
          ],
        ),
      ),
    );
  }

  void continueToGameClicked() async {
    // this.widget.usersLogin =
    //     await GameDatabaseService().getPlayersList(this.widget.gameId);
    _eventsSubscription.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QuartetsRoom(this.widget.usersLogin,
              this.widget.gameId, widget.isBoss, false)),
    );
    //GameDatabaseService().updateContinueState(this.widget.gameId);
  }

  String cleanGameId(String s) {
    return s.substring(2, s.length - 1);
  }

  Widget getListNameUsers() {
    return StreamBuilder<List<String>>(
        stream: _usersLoginStreamController.stream,
        initialData: [],
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 7),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Text(
                    snapshot.data[index],
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'AkayaK-e',
                      color: Colors.pink,
                    ),
                  ),
                );
              });
        });
  }

  // Widget getUserLogin() {
  //   return StreamBuilder<List<String>>(
  //       stream: _usersLoginStreamController.stream,
  //       builder: (context, snapshot) {
  //         return Text(
  //           snapshot.data != null
  //               ? snapshot.data + " התחבר "
  //               : "...מחכה להתחברות שחקנים נוספים",
  //         );
  //       });
  // }

}
