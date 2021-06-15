import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/players/player.dart';
import 'package:flutter/cupertino.dart';

class GameDatabaseService {
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('games');

  Future updateGame(bool finished, List<Player> players, int turn, Deck deck,
      String id, List<String> subjects) async {
    return await gameCollection.doc(id).set({
      'finished': finished,
      'players': players,
      'turn': turn,
      'deck': deck,
      'gameId': id,
      'subjects': subjects,
    });
  }

  Future addPlayer(String gameId, String name) async {
    List<int> cards = [];
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

  Future<List<String>> getSubjectsList(
    String subjectsId,
  ) async {
    List<String> subjectsList;
    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(subjectsId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot.data()["subjects_list"]);
        var x = documentSnapshot.data()["subjects_list"];
        List<String> strList = x.cast<String>();
        subjectsList = strList;
      }
    });
    return Future.value(subjectsList);
  }

  Future updateSubjectList(String gameId, List<String> subList) async {
    return await gameCollection.doc(gameId).update({
      'subjects': subList,
    });
  }
}
