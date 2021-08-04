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
    print("against computer");
    print(ac);
    await gameCollection.doc(gameId).update({'againstComputer': ac});
  }

  // return 1 if succeed.
  // 2 - too much players ( more then 4)
  // 3 no exist this code
  Future<int> addPlayer(String gameId, String name, String id) async {
    print("add player:");
    print(name);
    List<int> cards = [];
    await gameCollection.doc(gameId).collection("players").doc(id).set({
      'cards': cards,
      'name': name,
      'score': 0,
    });
    return await gameCollection
        .doc(gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()['players'];
        List<String> newPlayersList = x.cast<String>();
        newPlayersList.add(name);
        print("new Player list: ");
        print(newPlayersList);
        if (newPlayersList.length <= 4) {
          gameCollection.doc(gameId).update({'players': newPlayersList});
          return Future.value(1);
        } else {
          return Future.value(2);
        }
      } else {
        return Future.value(3);
      }
    });
    //check?
//    print("4");
//    return Future.value(1);
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
    Triple card1 = await createTriple("card1", document);
    Triple card2 = await createTriple("card2", document);
    Triple card3 = await createTriple("card3", document);
    Triple card4 = await createTriple("card4", document);
    Subject sub1 = Subject(subName, card1, card2, card3, card4);
    return Future.value(sub1);
  }

  Future<Triple> createTriple(
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
    await gameCollection.doc(gameId).update({
      'continueToGame': true,
    });
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
            print("here:");
            print(p.name);
          } else {
            p = ComputerPlayer(cards, value.data()["name"], value.id);
            print("here:");
            print(p.name);
          }
          players.add(p);
        }
        game.addToListTurn(p);
      });
    });
    print("players:");
    print(players);
    return Future.value(players);
  }

  void addSeries(String nameSeries, String eng1, String heb1, String eng2,
      String heb2, String eng3, String heb3, String eng4, String heb4) async {
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
  }

  void initializePlayerCard(
      List<int> cards, QuartetsGame game, String playerId) async {
//    if (!game.againstComputer) {
    await gameCollection
        .doc(game.gameId)
        .collection("players")
        .doc(playerId)
        .update({'cards': cards});
//    }
  }

  void updateDeck(List<int> cards, QuartetsGame game) async {
//    if (!game.againstComputer) {
    await gameCollection.doc(game.gameId).update({'deck': cards});
//    }
  }

  // Future<List<int>> getDeck(String gameId) async {
  //   List<int> d;
  //   await gameCollection
  //       .doc(gameId)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       var x = documentSnapshot.data()["deck"];
  //       d = x;
  //     }
  //   });
  //   return Future.value(d);
  // }

  void updateTakeCardFromDeck(
      QuartetsGame game, CardQuartets card, Player player) {
//    if (!game.againstComputer) {
    deleteCardFromDeck(game, card);
    addCardToPlayer(game, card, player);
//    }
  }

  void deleteCardFromDeck(QuartetsGame game, CardQuartets card) async {
//    if (!game.againstComputer) {
    List<int> newDeck = [];
    await gameCollection
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
        gameCollection.doc(game.gameId).update({'deck': newDeck});
      }
    });
//    }
  }

  void addCardToPlayer(
      QuartetsGame game, CardQuartets card, Player player) async {
//    if (!game.againstComputer) {
    await gameCollection
        .doc(game.gameId)
        .collection("players")
        .doc(player.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var x = documentSnapshot.data()['cards'];
        List<int> playerCards = x.cast<int>();
        int cardId = game.cardsId[card];
        playerCards.add(cardId);
        gameCollection
            .doc(game.gameId)
            .collection("players")
            .doc(player.uid)
            .update({'cards': playerCards});
      }
    });
//    }
  }

  void deleteCardToPlayer(
      Player player, QuartetsGame game, CardQuartets card) async {
//    if (!game.againstComputer) {
    await gameCollection
        .doc(game.gameId)
        .collection("players")
        .doc(player.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
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
        gameCollection
            .doc(game.gameId)
            .collection("players")
            .doc(player.uid)
            .update({'cards': updateList});
      }
    });
//    }
  }

  void transferCard(Player takePlayer, Player tokenFrom, QuartetsGame game,
      CardQuartets card) {
//    if (!game.againstComputer) {
    deleteCardToPlayer(tokenFrom, game, card);
    addCardToPlayer(game, card, takePlayer);
//    }
  }

  void updateTurn(QuartetsGame game, int turn) {
//    if (!game.againstComputer) {
    gameCollection.doc(game.gameId).update({'turn': turn});
//    }
  }

  void updateScore(int score, playerId, QuartetsGame game) async {
//    if (!game.againstComputer) {
    await gameCollection
        .doc(game.gameId)
        .collection("players")
        .doc(playerId)
        .update({'score': score});
//    }
  }

  Future<List<CardGame>> getPlayerCards(
      QuartetsGame game, Player player) async {
    List<CardGame> cardsPlayer = [];
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
    for (CardQuartets c in cardsPlayer) {
      if (player is Me) {
        c.changeToMine();
      } else {
        c.changeToNotMine();
      }
    }
    return Future.value(cardsPlayer);
  }

  void updateInitializeGame(QuartetsGame game) async {
    await gameCollection.doc(game.gameId).update({'initializeGame': true});
  }

  Future<List<CardQuartets>> getDeck(QuartetsGame game) {
    List<CardQuartets> deck = [];
    gameCollection
        .doc(game.gameId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var simpleDeck = documentSnapshot.data()['deck'];
        simpleDeck = simpleDeck.cast<int>();
        for (int i in simpleDeck) {
          CardQuartets iKey = game.cardsId.keys
              .firstWhere((k) => game.cardsId[k] == i, orElse: () => null);
          deck.add(iKey);
        }
      }
    });
    return Future.value(deck);
  }

  Future<int> getTurn(QuartetsGame game) async {
    int newTurn;
    gameCollection.doc(game.gameId).get().then((value) {
      if (value.exists) {
        var turn = value.data()['turn'];
        newTurn = turn.cast<int>();
      }
    });
    return Future.value(newTurn);
  }

  void deleteQuartet(
      Subject subjectToDelete, QuartetsGame game, Player player) async {
    List<int> newCardsList = [];
    for (CardQuartets i in player.cards) {
      newCardsList.add(game.cardsId[i]);
    }
    for (CardQuartets c in subjectToDelete.cards) {
      newCardsList.remove(game.cardsId[c]);
    }
    await gameCollection
        .doc(game.gameId)
        .collection('players')
        .doc(player.uid)
        .update({'cards': newCardsList});
  }

  Future<int> getCardToken(QuartetsGame game) async {
    int cardToken;
    gameCollection.doc(game.gameId).get().then((value) {
      if (value.exists) {
        var cToken = value.data()['cardToken'];
        cardToken = cToken.cast<int>();
      }
    });
    return Future.value(cardToken);
  }

  Future<int> getTake(QuartetsGame game) async {
    int take;
    gameCollection.doc(game.gameId).get().then((value) {
      if (value.exists) {
        var cTake = value.data()['take'];
        take = cTake.cast<int>();
      }
    });
    return Future.value(take);
  }

  Future<int> getTokenFrom(QuartetsGame game) async {
    int tokenFrom;
    gameCollection.doc(game.gameId).get().then((value) {
      if (value.exists) {
        var tokenF = value.data()['tokenFrom'];
        tokenFrom = tokenF.cast<int>();
      }
    });
    return Future.value(tokenFrom);
  }

  void updateTake(
      QuartetsGame game, int take, int token, String sub, int card, bool succ) {
//    if (!game.againstComputer) {
    gameCollection.doc(game.gameId).update({
      'take': take,
      'tokenFrom': token,
      'cardToken': card,
      'subjectAsk': sub,
      'success': succ
    });
//    }
  }

  void deleteSeries(
      String seriesName, String playerId, List<String> newListSub) async {
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
  }

  void updateGeneric(String gameId, bool gen) {
    gameCollection.doc(gameId).update({'generic': gen});
  }

  void updateGetQuartet(String gameId, String name) async {
    // "update my name in get quartet"
    gameCollection.doc(gameId).update({'getQuartet': name});
    await Future.delayed(new Duration(seconds: 2));
    // update null in get quartet
    gameCollection.doc(gameId).update({'getQuartet': null});
  }

  Future<String> getGetQuartetName(String gameId) async {
    String name;
    await gameCollection.doc(gameId).get().then((value) {
      if (value.exists) {
        name = value.data()['getQuartet'].cast<String>();
      }
    });
    return Future.value(name);
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
    await gameCollection.doc(gameId).collection('players').get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
    await gameCollection.doc(gameId).delete();
  }

  void updateFinished(String gameId, bool isFinished) {
    gameCollection.doc(gameId).update({'finished': isFinished});
  }
}
