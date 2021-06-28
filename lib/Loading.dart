import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/QuartetsRoom.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'cards/Subject.dart';

class Loading extends StatefulWidget {
  bool isBoss;
  List<Player> usersLogin;
  List<Subject> subjects;
  final Map<String, int> cardsId = {};
  String gameId;

  Loading(String gameId, bool isBoss) {
    this.usersLogin = [];
    this.subjects = [];
    this.isBoss = isBoss;
    createAllSubjects(gameId);
    this.gameId = gameId;
  }
  Future createAllSubjects(String gameId) async {
    int z = 0;
    List<String> strSub =
        await GameDatabaseService().getGameListSubjects(gameId);
    String subjectId = await GameDatabaseService().getSucjectsId(gameId);
    for (String s in strSub) {
      Subject sub = await GameDatabaseService()
          .createSubjectFromDatabase("generic_subjects", s);
      subjects.add(sub);
      List<String> nameCards = sub.getNamesCards();
      int nameCardLen = nameCards.length;
      for (int i = 0; i < nameCardLen; i++) {
        String cardId = sub.name_subject + nameCards[i];
        this.cardsId[cardId] = z;
        z++;
      }
    }
    print(this.cardsId.toString());
  }

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final _usersLoginStreamController = StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("games")
        .doc(this.widget.gameId)
        .snapshots()
        .listen((event) {
      if (event.data()['continueToGame'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuartetsRoom(this.widget.usersLogin,
                  this.widget.subjects, this.widget.cardsId)),
        );
      }
    });
    //listen
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
                  //testIfContinue(),
                  getListNameUsers(),
                  SizedBox(
                    height: 30,
                  ),
                  getUserLogin(),
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
    this.widget.usersLogin =
        await GameDatabaseService().getPlayersList(this.widget.gameId);
    GameDatabaseService().changeContinueState(this.widget.gameId);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => QuartetsRoom(this.widget.usersLogin,
    //           this.widget.subjects, this.widget.cardsId)),
    // );
  }

  Widget getListNameUsers() {
    return StreamBuilder<String>(
        stream: _usersLoginStreamController.stream,
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: this.widget.usersLogin.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  this.widget.usersLogin[index].name,
                );
              });
        });
  }

  Widget getUserLogin() {
    return StreamBuilder<String>(
        stream: _usersLoginStreamController.stream,
        builder: (context, snapshot) {
          return Text(
            snapshot.data != null
                ? snapshot.data + " התחבר "
                : "מחכה להתחברות שחקנים נוספים...",
          );
        });
  }

  void addUser(User user) {
    this._usersLoginStreamController.add(user.displayName);
  }

  void removeUser(User user) {
    //TODO: change it
    this._usersLoginStreamController.add(user.displayName);
  }

  // Future<Widget> testIfContinue() async {
  //   StreamBuilder<DocumentSnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection("games")
  //           .doc(widget.gameId)
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.data != null) {
  //           if (snapshot.data['continueToGame'] == true) {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => QuartetsRoom(this.widget.usersLogin,
  //                       this.widget.subjects, this.widget.cardsId)),
  //             );
  //           }
  //         }
  //         return SizedBox();
  //       });
  // }
}
