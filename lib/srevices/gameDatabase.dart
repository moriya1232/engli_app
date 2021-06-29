import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/CardGame.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/players/player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GameDatabaseService {
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('games');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future updateGame(bool finished, List<Player> players, int turn, Deck deck,
      String id, List<String> subjects, subjectsId, con) async {
    return await gameCollection.doc(id).set({
      'finished': finished,
      'players': players,
      'turn': turn,
      'deck': deck,
      'gameId': id,
      'subjects': subjects,
      'subjectsId': subjectsId,
      'continueToGame': con
    });
  }

  Future addPlayer(String gameId, String name) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
    List<int> cards = [];
    await FirebaseFirestore.instance
        .collection("games")
        .doc(gameId)
        .collection("players")
        .doc(user.uid.toString())
        .set({
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
        card.hebrew = ds.data()["hebrew"];
        card.image = Image(image: AssetImage(ds.data()["image"]));
      }
    });
    return Future.value(card);
  }

  void changeContinueState(gameId) async {
    await gameCollection.doc(gameId).update({
      'continueToGame': true,
    });
  }

  Future<List<Player>> getPlayersList(String gameId) async {
    List<Player> players = [];
    await FirebaseFirestore.instance
        .collection("games")
        .doc(gameId)
        .collection("players")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        List<CardGame> cards = [];
        final FirebaseAuth _auth = FirebaseAuth.instance;
        User user = _auth.currentUser;
        print(value.id);
        print(user.uid);
        if (value.id.toString() == user.uid) {
          players.add(Me(cards, value.data()["name"]));
        } else {
          players.add(VirtualPlayer(cards, value.data()["name"]));
        }
      });
    });
  }

  void addSeries(String nameSeries, String eng1, String heb1, String eng2,
      String heb2, String eng3, String heb3, String eng4, String heb4) async {
    List<String> sub = [];
    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(_auth.currentUser.uid.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()["subjects_list"];
        sub = x.cast<String>();
      }
    });
    sub.add(nameSeries);
    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(_auth.currentUser.uid.toString())
        .set({'subjects_list': sub});
    //
    // bool ifDocExist = false;
    // await FirebaseFirestore.instance
    //     .collection("subjects")
    //     .doc(_auth.currentUser.uid.toString())
    //     .get()
    //     .then((doc) {
    //   if (doc.exists) {
    //     ifDocExist = true;
    //   } else {
    //     ifDocExist = false;
    //   }
    // });
    // List<String> subjectList = [nameSeries];
    // if (!ifDocExist) {
    //   print("NOT EXIST!");
    //   await FirebaseFirestore.instance
    //       .collection("subjects")
    //       .doc(_auth.currentUser.uid.toString())
    //       .set({
    //     'subject_list': subjectList,
    //   });
    // } else {
    //   print("EXIST!");
    //   await FirebaseFirestore.instance
    //       .collection("subjects")
    //       .doc(_auth.currentUser.uid.toString())
    //       .update({
    //     'subject_list': FieldValue.arrayUnion(subjectList),
    //   });
    // }

    //save the quarters
    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(this._auth.currentUser.uid.toString())
        .collection("user_subjects")
        .doc(nameSeries)
        .collection("cards")
        .doc("card1")
        .set({'english': eng1, 'hebrew': heb1, 'image': null});
    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(this._auth.currentUser.uid.toString())
        .collection("user_subjects")
        .doc(nameSeries)
        .collection("cards")
        .doc("card2")
        .set({'english': eng2, 'hebrew': heb2, 'image': null});
    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(this._auth.currentUser.uid.toString())
        .collection("user_subjects")
        .doc(nameSeries)
        .collection("cards")
        .doc("card3")
        .set({'english': eng3, 'hebrew': heb3, 'image': null});
    await FirebaseFirestore.instance
        .collection("subjects")
        .doc(this._auth.currentUser.uid.toString())
        .collection("user_subjects")
        .doc(nameSeries)
        .collection("cards")
        .doc("card4")
        .set({'english': eng4, 'hebrew': heb4, 'image': null});
  }
}
