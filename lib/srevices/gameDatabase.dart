import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/CardGame.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameDatabaseService {
  final CollectionReference gameCollection =
      FirebaseFirestore.instance.collection('games');
  final CollectionReference subjectCollection =
      FirebaseFirestore.instance.collection('subjects');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future updateGame(bool finished, List<String> players, int turn, Deck deck,
      String id, List<String> subjects, subjectsId, con) async {
    players = [];
    return await gameCollection.doc(id).set({
      'finished': false,
      'players': players,
      'turn': turn,
      'deck': deck,
      'gameId': id,
      'subjects': subjects,
      'managerId': subjectsId,
      'continueToGame': con,
      'initializeGame': false,
      'tokenFrom': null,
      'take': null,
      'cardToken': null,
      'subjectAsk': null,
      'success': false,
      'generic': false,
      'getQuartet': null,
      'againstComputer': false
    });
  }

  void updateAgainstComputer(String gameId, bool ac) async {
    try {
      await gameCollection.doc(gameId).update({'againstComputer': ac});
    } catch (e) {
      print("ERROR! updateAgainstComputer");
    }
  }

  // return 1 if succeed.
  // 2 - too much players ( more then 4)
  // 3 no exist this code
  Future<int> addPlayerToDataBase(String gameId, String name, String id) async {
    List<int> cards = [];
    await gameCollection.doc(gameId).collection("players").doc(id).set({
      'cards': cards,
      'name': name,
      'score': 0,
    });
    return await gameCollection
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()['players'];
        List<String> newPlayersList = x.cast<String>();
        newPlayersList.add(name);
        if (newPlayersList.length <= 4) {
          await gameCollection.doc(gameId).update({'players': newPlayersList});
          return Future.value(1);
        } else {
          return Future.value(2);
        }
      } else {
        return Future.value(3);
      }
    });
  }

  Future<List<String>> getSubjectsList(
    String subjectsId,
  ) async {
    List<String> subjectsList;
    await subjectCollection
        .doc(subjectsId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()["subjects_list"];
        if (x == null) {
          return null;
        }
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
    List<String> subjectsList = [];
    await gameCollection
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()["subjects"];
        List<String> strList = x.cast<String>();
        subjectsList = strList;
      }
    });
    return Future.value(subjectsList);
  }

  Future<String> getManagerId(gameId) async {
    String subjectsId;
    await gameCollection
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()['managerId'];
        subjectsId = x;
      }
    });
    return Future.value(subjectsId);
  }

  Future<Subject> createSubjectFromDatabase(
      String collectionName, String subName) async {
    var document = FirebaseFirestore.instance
        .collection("subjects/")
        .doc(collectionName)
        .collection("user_subjects")
        .doc(subName)
        .collection("cards");
    try {
      Triple card1 = await createTripleFromDataBase("card1", document);
      Triple card2 = await createTripleFromDataBase("card2", document);
      Triple card3 = await createTripleFromDataBase("card3", document);
      Triple card4 = await createTripleFromDataBase("card4", document);
      Subject sub1 = Subject(subName, card1, card2, card3, card4);
      return Future.value(sub1);
    } catch (e) {
      print("ERROR createTripleFromDatabase $e");
    }
  }

  Future<Triple> createTripleFromDataBase(
      String specCard, CollectionReference document) async {
    Triple card;
    await document.doc(specCard).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        card = Triple(
            ds.data()["english"], ds.data()["hebrew"], ds.data()["image"]);
      }
    });
    return Future.value(card);
  }

  void updateContinueState(gameId) async {
    try {
      await gameCollection.doc(gameId).update({
        'continueToGame': true,
      });
    } catch (e) {
      print("ERROR updateContinueState $e");
    }
  }

  Future<bool> getContinueState(gameId) async {
    bool x;
    await gameCollection
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        x = documentSnapshot.data()['continueToGame'];
      }
    });
    return Future.value(x);
  }

  Future<List<Player>> getPlayersList(QuartetsGame game) async {
    List<Player> players = [null];
    bool againstComputer = false;
    await gameCollection.doc(game.gameId).get().then((value) {
      if (value.exists) {
        var ac = value.data()['againstComputer'];
        if (ac) {
          againstComputer = true;
        }
      }
    });
    await gameCollection
        .doc(game.gameId)
        .collection("players")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((value) {
        List<CardGame> cards = [];
        final FirebaseAuth _auth = FirebaseAuth.instance;
        User user = _auth.currentUser;
        Player p;
        if (value.id.toString() == user.uid) {
          p = Me(cards, value.data()["name"], value.id);
          players[0] = p;
        } else {
          if (!againstComputer) {
            p = VirtualPlayer(cards, value.data()["name"], value.id);
          } else {
            p = ComputerPlayer(cards, value.data()["name"], value.id);
          }
          players.add(p);
        }
        game.addToListTurn(p);
      });
    });
    return Future.value(players);
  }

  void addSeriesToDataBase(
      String nameSeries,
      String eng1,
      String heb1,
      String eng2,
      String heb2,
      String eng3,
      String heb3,
      String eng4,
      String heb4) async {
    try {
      //update the subjects list
      List<String> sub = [];
      await subjectCollection
          .doc(_auth.currentUser.uid.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var x = documentSnapshot.data()["subjects_list"];
          sub = x.cast<String>();
        }
      });
      sub.add(nameSeries);
      await subjectCollection
          .doc(_auth.currentUser.uid.toString())
          .set({'subjects_list': sub});

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
    } catch (e) {
      print("ERROR addSeriesToDataBase $e");
    }
  }

  void updatePlayerCards(
      List<int> cards, QuartetsGame game, String playerId) async {
    try {
      await gameCollection
          .doc(game.gameId)
          .collection("players")
          .doc(playerId)
          .update({'cards': cards});
    } catch (e) {
      print("ERROR updatePlayerCards $e");
    }
  }

  void updateDeck(List<int> cards, QuartetsGame game) async {
    try {
      await gameCollection.doc(game.gameId).update({'deck': cards});
    } catch (e) {
      print("ERROR updateDeck $e");
    }
  }

  void updateTakeCardFromDeck(
      QuartetsGame game, CardQuartets card, Player player) async {
    try {
      await deleteCardFromDeck(game, card);
      await addCardToPlayer(game, card, player);
    } catch (e) {
      print("ERROR updateTakeCardFromDeck $e");
    }
  }

  void deleteCardFromDeck(QuartetsGame game, CardQuartets card) async {
    try {
      List<int> newDeck = [];
      await gameCollection
          .doc(game.gameId)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          var x = documentSnapshot.data()["deck"];
          List<int> deck = x.cast<int>();
          int cardId = game.cardsId[card];
          for (int c in deck) {
            if (c != cardId) {
              newDeck.add(c);
            }
          }
          await gameCollection.doc(game.gameId).update({'deck': newDeck});
        }
      });
    } catch (e) {
      print("ERROR deleteCadFromDeck $e");
    }
  }

  void addCardToPlayer(
      QuartetsGame game, CardQuartets card, Player player) async {
    try {
      await gameCollection
          .doc(game.gameId)
          .collection("players")
          .doc(player.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          var x = documentSnapshot.data()['cards'];
          List<int> playerCards = x.cast<int>();
          int cardId = game.cardsId[card];
          playerCards.add(cardId);
          await gameCollection
              .doc(game.gameId)
              .collection("players")
              .doc(player.uid)
              .update({'cards': playerCards});
        }
      });
    } catch (e) {
      print("ERROR addCardToPlayer $e");
    }
  }

  void deleteCardToPlayer(
      Player player, QuartetsGame game, CardQuartets card) async {
    try {
      await gameCollection
          .doc(game.gameId)
          .collection("players")
          .doc(player.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          List<int> updateList = [];
          var x = documentSnapshot.data()['cards'];
          List<int> playerCards = x.cast<int>();
          int cardId = game.cardsId[card];
          for (int c in playerCards) {
            if (c != cardId) {
              updateList.add(c);
            }
          }
          await gameCollection
              .doc(game.gameId)
              .collection("players")
              .doc(player.uid)
              .update({'cards': updateList});
        }
      });
    } catch (e) {
      print("ERROR deleteCardToPlayer $e");
    }
  }

  void transferCard(Player takePlayer, Player tokenFrom, QuartetsGame game,
      CardQuartets card) async {
    try {
      await deleteCardToPlayer(tokenFrom, game, card);
      await addCardToPlayer(game, card, takePlayer);
    } catch (e) {
      print("ERROR transferCard $e");
    }
  }

  void updateTurn(QuartetsGame game, int turn) async {
    try {
      await gameCollection.doc(game.gameId).update({'turn': turn});
    } catch (e) {
      print("ERROR updateTurn $e");
    }
  }

  void updateScore(int score, playerId, QuartetsGame game) async {
    try {
      await gameCollection
          .doc(game.gameId)
          .collection("players")
          .doc(playerId)
          .update({'score': score});
    } catch (e) {
      print("ERROR updateScore $e");
    }
  }

  void updateInitializeGame(QuartetsGame game) async {
    try {
      await gameCollection.doc(game.gameId).update({'initializeGame': true});
    } catch (e) {
      print("ERROR updateInitializeGame $e");
    }
  }

  void deleteQuartet(
      Subject subjectToDelete, QuartetsGame game, Player player) async {
    try {
      List<int> newCardsList = [];
      for (CardQuartets i in player.cards) {
        newCardsList.add(game.cardsId[i]);
      }
      for (CardQuartets c in subjectToDelete.cards) {
        player.cards.remove(c);
        newCardsList.remove(game.cardsId[c]);
      }
      await gameCollection
          .doc(game.gameId)
          .collection('players')
          .doc(player.uid)
          .update({'cards': newCardsList});
    } catch (e) {
      print("ERROR deleteQuartet $e");
    }
  }

  void updateTake(QuartetsGame game, int take, int token, String sub, int card,
      bool succ) async {
    try {
      await gameCollection.doc(game.gameId).update({
        'take': take,
        'tokenFrom': token,
        'cardToken': card,
        'subjectAsk': sub,
        'success': succ
      });
    } catch (e) {
      print("ERROR updateTake $e");
    }
  }

  void deleteSubjectFromDataBase(
      String seriesName, String playerId, List<String> newListSub) async {
    try {
      await subjectCollection
          .doc(playerId)
          .collection('user_subjects')
          .doc(seriesName)
          .collection('cards')
          .doc('card1')
          .delete();
      await subjectCollection
          .doc(playerId)
          .collection('user_subjects')
          .doc(seriesName)
          .collection('cards')
          .doc('card2')
          .delete();
      await subjectCollection
          .doc(playerId)
          .collection('user_subjects')
          .doc(seriesName)
          .collection('cards')
          .doc('card3')
          .delete();
      await subjectCollection
          .doc(playerId)
          .collection('user_subjects')
          .doc(seriesName)
          .collection('cards')
          .doc('card4')
          .delete();
      await subjectCollection
          .doc(playerId)
          .collection('user_subjects')
          .doc(seriesName)
          .delete();
      subjectCollection.doc(playerId).update({'subjects_list': newListSub});
    } catch (e) {
      print("ERROR deleteSubjectFromDataBase $e");
    }
  }

  void updateGeneric(String gameId, bool gen) async {
    try {
      await gameCollection.doc(gameId).update({'generic': gen});
    } catch (e) {
      print("ERROR updateeneric $e");
    }
  }

  void updateGetQuartet(String gameId, String name) async {
    try {
      // "update my name in get quartet"
      await gameCollection.doc(gameId).update({'getQuartet': name});
      await Future.delayed(new Duration(seconds: 2));
      // update null in get quartet
      await gameCollection.doc(gameId).update({'getQuartet': null});
    } catch (e) {
      print("ERROR updateGetQuartet $e");
    }
  }

  Future<bool> getGenerics(gameId) async {
    bool gen;
    await gameCollection.doc(gameId).get().then((value) {
      if (value.exists) {
        gen = value.data()['generic'];
      }
    });
    return Future.value(gen);
  }

  Future<bool> getAgainstComputer(gameId) async {
    bool aga;
    await gameCollection.doc(gameId).get().then((value) {
      if (value.exists) {
        aga = value.data()['againstComputer'];
      }
    });
    return Future.value(aga);
  }

  void deleteGame(String gameId) async {
    try {
    await gameCollection.doc(gameId).collection('players').get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
    await gameCollection.doc(gameId).delete();
    } catch (e) {
      print("ERROR deleteGame $e");
    }
  }

  void updateFinished(String gameId, bool isFinished) async {
    try {
    await gameCollection.doc(gameId).update({'finished': isFinished});
    } catch (e) {
      print("ERROR updateFinished $e");
    }
  }
}
