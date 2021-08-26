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
      String id, List<String> subjects, subjectsId, con) {
    players = [];
    return gameCollection.doc(id).set({
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
      print("ERROR updateAgainstComputer: $e");
    }
  }

  // return 1 if succeed.
  // 2 - too much players ( more then 4)
  // 3 no exist this code
  Future<int> addPlayerToDataBase(String gameId, String name, String id) async{
    List<int> cards = [];
    try {
      int result = await gameCollection.doc(gameId).collection("players").doc(
          id).set({
        'cards': cards,
        'name': name,
        'score': 0,
      }).then((_) =>
          gameCollection
              .doc(gameId)
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              var x = documentSnapshot.data()['players'];
              List<String> newPlayersList = x.cast<String>();
              newPlayersList.add(name);
              if (newPlayersList.length <= 4) {
                await gameCollection.doc(gameId).update(
                    {'players': newPlayersList});
                return 1;
              } else {
                return 2;
              }
            } else {
              return 3;
            }
          }));
      return result;
    } catch (e) {
      print("addPlayerToDataBase: $e");
      return null;
    }
  }

  Future<List<String>> getSubjectsList(
    String subjectsId,
  ) async {
    try {
      final docSnap = await subjectCollection.doc(subjectsId).get();
      if (!docSnap.exists) return null;
      final x = docSnap.data()["subjects_list"];
      final subjectsList = x.cast<String>();
      return subjectsList;
    } catch (e){
      print("ERROR getSubjectsList: $e");
      return null;
    }
  }

  void updateSubjectList(String gameId, List<String> subList) async{
    try {
      await gameCollection.doc(gameId).update({
        'subjects': subList,
      });
    } catch (e) {
      print("ERROR updateSubjectList: $e");
    }
  }

  Future<List<String>> getGameListSubjects(gameId) async {
    List<String> subjectsList = [];
    try {
      await gameCollection
          .doc(gameId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var x = documentSnapshot.data()["subjects"];
          List<String> strList = x.cast<String>();
          subjectsList = strList;
          subjectsList = strList;
        }
      });
      return Future.value(subjectsList);
    } catch (e) {
      print("ERROR getGameListSubjects: $e");
      return null;
    }
  }

  Future<String> getManagerId(gameId)  {
    return gameCollection
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) return null;
      return documentSnapshot.data()['managerId'];
    });
  }

  Future<Subject> createSubjectFromDatabase(
      String collectionName, String subName) async {
    try {
      var document = FirebaseFirestore.instance
          .collection("subjects/")
          .doc(collectionName)
          .collection("user_subjects")
          .doc(subName)
          .collection("cards");
      Triple card1 = await createTripleFromDataBase("card1", document);
      Triple card2 = await createTripleFromDataBase("card2", document);
      Triple card3 = await createTripleFromDataBase("card3", document);
      Triple card4 = await createTripleFromDataBase("card4", document);
      Subject sub1 = Subject(subName, card1, card2, card3, card4);
      return sub1;
    } catch (e) {
      print("ERROR createSubjectFromDatabase: $e");
      return null;
    }
  }

  Future<Triple> createTripleFromDataBase(
      String specCard, CollectionReference document) {
    Triple card;
    return document.doc(specCard).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        card = Triple(
            ds.data()["english"], ds.data()["hebrew"], ds.data()["image"]);
            return card;
      }
      return null;
    });
  }

  void updateContinueState(gameId) async {
    try {
      await gameCollection.doc(gameId).update({
        'continueToGame': true,
      });
    } catch (e) {
      print("ERROR updateContinueState: $e");
      return null;
    }
  }

  Future<bool> getContinueState(gameId) {
    return gameCollection
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data()['continueToGame'];
      }
      return null;
    });
  }

  Future<List<Player>> getPlayersList(QuartetsGame game) async {
    List<Player> players = [null];
    bool againstComputer = false;
    try {
      await gameCollection.doc(game.gameId).get().then((value) {
        if (value.exists) {
          var ac = value.data()['againstComputer'];
          if (ac) {
            againstComputer = true;
          }
        }
      }).then((_) =>
          gameCollection
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
          }));
    } catch (e) {
      print("ERROR getPlayersList: $e");
      return null;
    }
    return players;
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
    //update the subjects list
    List<String> sub = [];
    try {
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
    } catch (e) {
      print("ERROR addSeriesToDataBase1: $e");
      return null;
    }
    try {
      //save the quarters
      await FirebaseFirestore.instance
          .collection("subjects")
          .doc(this._auth.currentUser.uid.toString())
          .collection("user_subjects")
          .doc(nameSeries)
          .collection("cards")
          .doc("card1")
          .set({'english': eng1, 'hebrew': heb1, 'image': null}).then((_) =>
          FirebaseFirestore.instance
              .collection("subjects")
              .doc(this._auth.currentUser.uid.toString())
              .collection("user_subjects")
              .doc(nameSeries)
              .collection("cards")
              .doc("card2")
              .set({'english': eng2, 'hebrew': heb2, 'image': null})).then((
          _) =>
          FirebaseFirestore.instance
              .collection("subjects")
              .doc(this._auth.currentUser.uid.toString())
              .collection("user_subjects")
              .doc(nameSeries)
              .collection("cards")
              .doc("card3")
              .set({'english': eng3, 'hebrew': heb3, 'image': null})).then((
          _) =>
          FirebaseFirestore.instance
              .collection("subjects")
              .doc(this._auth.currentUser.uid.toString())
              .collection("user_subjects")
              .doc(nameSeries)
              .collection("cards")
              .doc("card4")
              .set({'english': eng4, 'hebrew': heb4, 'image': null}));
    } catch (e) {
      print("ERROR addSeriesToDataBase2: $e");
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
      print("ERROR updatePlayerCards: $e");
    }
  }

  void updateDeck(List<int> cards, QuartetsGame game) async {
    try {
      await gameCollection.doc(game.gameId).update({'deck': cards});
    } catch (e) {
      print("ERROR updateDeck: $e");
    }
  }

  void updateTakeCardFromDeck(
      QuartetsGame game, CardQuartets card, Player player) async {
    try {
      deleteCardFromDeck(game, card);
      addCardToPlayer(game, card, player);
    } catch(e) {
      print("ERROR updateTakeCardFromDeck: $e");
    }
  }

  void deleteCardFromDeck(QuartetsGame game, CardQuartets card) async {
    List<int> newDeck = [];
    try {
      gameCollection
          .doc(game.gameId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var x = documentSnapshot.data()["deck"];
          List<int> deck = x.cast<int>();
          int cardId = game.cardsId[card];
          for (int c in deck) {
            if (c != cardId) {
              newDeck.add(c);
            }
          }
        }
      }).then((value) =>
          gameCollection.doc(game.gameId).update({'deck': newDeck}));
    } catch (e) {
      print("ERROR deleteCardFromDeck: $e");
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
      print("ERROR addCardToPlayer: $e");
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
      print("ERROR deleteCardToPlayer: $e");
    }
  }

  void transferCard(Player takePlayer, Player tokenFrom, QuartetsGame game,
      CardQuartets card) {
    deleteCardToPlayer(tokenFrom, game, card);
    addCardToPlayer(game, card, takePlayer);
  }

  void updateTurn(QuartetsGame game, int turn) async {
    try {
      await gameCollection.doc(game.gameId).update({'turn': turn});
    } catch (e) {
      print("ERROR updateTurn: $e");
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
      print("ERROR updateScore: $e");
    }
  }

  Future<List<CardGame>> getPlayerCards(
      QuartetsGame game, Player player) async {
    List<CardGame> cardsPlayer = [];
    try {
      await gameCollection
          .doc(game.gameId)
          .collection('players')
          .doc(player.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var x = documentSnapshot.data()['cards'];
          List<int> intArrayCards = x.cast<int>();
          for (int i in intArrayCards) {
            CardQuartets iKey = game.cardsId.keys
                .firstWhere((k) => game.cardsId[k] == i, orElse: () => null);
            cardsPlayer.add(iKey);
          }
        }
      });
    } catch (e) {
      print("ERROR getPlayerCards: $e");
    }
    for (CardQuartets c in cardsPlayer) {
      if (player is Me) {
        c.changeToMine();
      } else {
        c.changeToNotMine();
      }
    }
    return cardsPlayer;
  }

  void updateInitializeGame(QuartetsGame game) async {
    try {
      await gameCollection.doc(game.gameId).update({'initializeGame': true});
    } catch (e) {
      print("ERROR updateInitializeGame: $e");
    }
  }

//  Future<List<CardQuartets>> getDeck(QuartetsGame game) {
//    List<CardQuartets> deck = [];
//    return gameCollection
//        .doc(game.gameId)
//        .get()
//        .then((DocumentSnapshot documentSnapshot) {
//      if (documentSnapshot.exists) {
//        var simpleDeck = documentSnapshot.data()['deck'];
//        simpleDeck = simpleDeck.cast<int>();
//        for (int i in simpleDeck) {
//          CardQuartets iKey = game.cardsId.keys
//              .firstWhere((k) => game.cardsId[k] == i, orElse: () => null);
//          deck.add(iKey);
//        }
//        return deck;
//      }
//      return null;
//    });
//  }

//  Future<int> getTurn(QuartetsGame game) {
//    int newTurn;
//    return gameCollection.doc(game.gameId).get().then((value) {
//      if (value.exists) {
//        var turn = value.data()['turn'];
//        newTurn = turn.cast<int>();
//        return newTurn;
//      }
//      return null;
//    });
//  }

  void deleteQuartet(
      Subject subjectToDelete, QuartetsGame game, Player player) async {
    List<int> newCardsList = [];
    for (CardQuartets i in player.cards) {
      newCardsList.add(game.cardsId[i]);
    }
    for (CardQuartets c in subjectToDelete.cards) {
      player.cards.remove(c);
      newCardsList.remove(game.cardsId[c]);
    }
    try {
      await gameCollection
          .doc(game.gameId)
          .collection('players')
          .doc(player.uid)
          .update({'cards': newCardsList});
    } catch (e) {
      print("ERROR deleteQuartet: $e");
    }
  }

//  Future<int> getCardToken(QuartetsGame game) {
//    int cardToken;
//    return gameCollection.doc(game.gameId).get().then((value) {
//      if (value.exists) {
//        var cToken = value.data()['cardToken'];
//        cardToken = cToken.cast<int>();
//        return cardToken;
//      }
//      return null;
//    });
//  }

//  Future<int> getTake(QuartetsGame game) {
//    int take;
//    return gameCollection.doc(game.gameId).get().then((value) {
//      if (value.exists) {
//        var cTake = value.data()['take'];
//        take = cTake.cast<int>();
//        return take;
//      }
//      return null;
//    });
//  }

//  Future<int> getTokenFrom(QuartetsGame game) async {
//    int tokenFrom;
//    await gameCollection.doc(game.gameId).get().then((value) {
//      if (value.exists) {
//        var tokenF = value.data()['tokenFrom'];
//        tokenFrom = tokenF.cast<int>();
//      }
//    });
//    return Future.value(tokenFrom);
//  }

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
      print("ERROR updateTake: $e");
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
          .delete().then((value) =>
          subjectCollection
              .doc(playerId)
              .collection('user_subjects')
              .doc(seriesName)
              .collection('cards')
              .doc('card2')
              .delete()).then((value) =>
          subjectCollection
              .doc(playerId)
              .collection('user_subjects')
              .doc(seriesName)
              .collection('cards')
              .doc('card3')
              .delete()).then((value) =>
          subjectCollection
              .doc(playerId)
              .collection('user_subjects')
              .doc(seriesName)
              .collection('cards')
              .doc('card4')
              .delete()).then((value) =>
          subjectCollection
              .doc(playerId)
              .collection('user_subjects')
              .doc(seriesName)
              .delete()).then((value) =>
          subjectCollection.doc(playerId).update(
              {'subjects_list': newListSub}));
    } catch (e) {
      print("ERROR deleteSubjectFromDataBase: $e");
    }
  }

  void updateGeneric(String gameId, bool gen) async {
    try {
      await gameCollection.doc(gameId).update({'generic': gen});
    } catch (e) {
      print("ERROR updateGeneric: $e");
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
      print("ERROR updateGetQuartet: $e");
    }
  }

//  Future<String> getGetQuartetName(String gameId) {
//    return gameCollection.doc(gameId).get().then((value) {
//      if (value.exists) {
//        return value.data()['getQuartet'].cast<String>();
//      }
//      return null;
//    });
//  }

  Future<bool> getGenerics(gameId) {
    return gameCollection.doc(gameId).get().then((value) {
      if (value.exists) {
        return value.data()['generic'];
      }
      return null;
    });
  }

  Future<bool> getAgainstComputer(gameId) {
    return gameCollection.doc(gameId).get().then((value) {
      if (value.exists) {
        return value.data()['againstComputer'];
      }
      return null;
    });
  }

  void deleteGame(String gameId) async {
    try {
      await gameCollection.doc(gameId).collection('players').get().then((
          value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      }).then((value) => gameCollection.doc(gameId).delete());
    } catch (e) {
      print("ERROR deleteGame: $e");
    }
  }

//  void updateFinished(String gameId, bool isFinished) async {
//    await gameCollection.doc(gameId).update({'finished': isFinished});
//  }
}
