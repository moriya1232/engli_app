import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/players/player.dart';
import 'package:flutter/material.dart';

class GameDatabaseService {
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('games');

  Future updateGame(bool finished, List<Player> players, int turn, Deck deck,
      String id, List<String> subjects, subjctsId) async {
    return await gameCollection.doc(id).set({
      'finished': finished,
      'players': players,
      'turn': turn,
      'deck': deck,
      'gameId': id,
      'subjects': subjects,
      'subjectsId': subjctsId,
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
        // print(documentSnapshot.data()["subjects_list"]);
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

  Future<List<String>> getGameListSubjects(gameId) async {
    List<String> subjectsList;
    await FirebaseFirestore.instance
        .collection("games")
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // print("ON LOADING:");
        // print(documentSnapshot.data()['subjects']);
        var x = documentSnapshot.data()["subjects"];
        List<String> strList = x.cast<String>();
        subjectsList = strList;
      }
    });
    return Future.value(subjectsList);
  }

  Future<String> getSucjectsId(gameId) async {
    String subjectsId;
    await FirebaseFirestore.instance
        .collection("games")
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()["subjectsId"];
        subjectsId = x;
      }
    });
    return Future.value(subjectsId);
  }

  Future<Subject> createSubjectFromDatabase(
      String collectionName, String subName) async {
    var document = await FirebaseFirestore.instance
        .collection("subjects/")
        .doc(collectionName)
        .collection("user_subjects")
        .doc(subName)
        .collection("cards");
    print("DOC!!");
    print(document.toString());
    Triple card1 = await createTriple("card1", document);
    Triple card2 = await createTriple("card2", document);
    Triple card3 = await createTriple("card3", document);
    Triple card4 = await createTriple("card4", document);
    Subject sub1 = Subject(subName, card1, card2, card3, card4);
    return Future.value(sub1);
  }

  Future<Triple> createTriple(
      String spec_card, CollectionReference document) async {
    Triple card = Triple(null, null, null);
    await document.doc(spec_card).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        card.english = ds.data()["english"];
        print("In METH");
        print(card.english);
        card.hebrew = ds.data()["hebrew"];
        card.image = Image(image: AssetImage(ds.data()["image"]));
      }
    });
    return Future.value(card);
  }
}
