import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/players/player.dart';
import 'package:flutter/cupertino.dart';

class GameDatabaseService {
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('games');

  Future updateGame(bool finished, List<Player> players, int turn, Deck deck,
      String id) async {
    return await gameCollection.doc(id).set({
      'finished': finished,
      'players': players,
      'turn': turn,
      'deck': deck,
      'gameId': id,
    });
  }
}
