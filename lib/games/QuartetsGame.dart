import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/cards/Position.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../Constants.dart';
import 'Game.dart';

class QuartetsGame extends Game {
  Deck deck;
  String playerTakeName;
  String playerTokenName;
  String subjectAsked;
  String cardAsked;
  bool successTakeCard;
  List<Subject> subjects;
  Map<CardQuartets, int> cardsId = {};
  bool isManager;
  String gameId;
  bool againstComputer = false;
  List<Player> listTurn = [];
  bool isFinished = false;
  StreamController _gameStart;
  // controllers for animate the view.
  StreamController _firstController;
  StreamController _secondController;
  StreamController _thirdController;
  StreamController _meController;
  StreamController _deckController;

  StreamController _turnController;

  StreamController _myCardsController;
  StreamController _myScoreController;
  StreamController _otherPlayersCardsController;
  StreamController _stringsOnDeckController;
  StreamController _isFinish;

  FlutterTts flutterTts = FlutterTts();

  QuartetsGame(
      String gameId,
      bool isManager,
      StreamController gameStart,
      StreamController sc1,
      StreamController sc2,
      StreamController sc3,
      StreamController scMe,
      StreamController scDeck,
      StreamController scTurn,
      StreamController myCards,
      StreamController myScore,
      StreamController otherCards,
      StreamController scStrings,
      StreamController isFinish)
      : this._gameStart = gameStart,
        this._firstController = sc1,
        this._secondController = sc2,
        this._thirdController = sc3,
        this._meController = scMe,
        this._deckController = scDeck,
        this._turnController = scTurn,
        this._stringsOnDeckController = scStrings,
        this._myCardsController = myCards,
        this._myScoreController = myScore,
        this._otherPlayersCardsController = otherCards,
        this._isFinish = isFinish {
    speak("Welcome to engli game!");

//    this.subjects = subs;
    this.isManager = isManager;
    this.gameId = gameId;
    this.subjects = [];
    this.listTurn = [];
    this.deck = new Deck(this.subjects);

    // this.cardsId = caID;
    this.playerTakeName = null;
    this.playerTokenName = null;
    this.subjectAsked = null;
    this.cardAsked = null;
    this.players = players;
  }

  void createGame() async {
    ///all players
//    if (!this.againstComputer) {
    this.players = await GameDatabaseService().getPlayersList(this);
//    } else {
//      this.listTurn.addAll(this.players);
//    }
    await createAllSubjects(gameId);

    /// only manager
    if (this.isManager) {
      await reStart();
      changeScoresOfPlayers();
    }

    ///listen to changes in specific game.
    FirebaseFirestore.instance
        .collection("games")
        .doc(this.gameId)
        .snapshots()
        .listen((event) {
      if (!this.isManager) {
        this._gameStart.add(true);
      }
      bool finished = event.data()['finished'];
      if (finished) {
        _isFinish.add(true);
      }
      //update tokens parameters
      int take = event.data()['take'];
      String takeName;
      if (take != null) {
        takeName = this.listTurn[take].name;
      }
      int token = event.data()['tokenFrom'];
      String tokenName;
      if (token != null && token >= 0) {
        tokenName = this.listTurn[token].name;
      }
      int cardToken = event.data()['cardToken'];
      String cardName;
      if (cardToken != null && cardToken >= 0) {
        cardName = this.idToCard(cardToken).english;
      }
      String subject = event.data()['subjectAsk'];
      bool succ = event.data()['success'];

      // animate card from player to player
      if ((succ &&
              cardName != null &&
              cardToken != -1 &&
              takeName != null &&
              tokenName != null) &&
          (this.playerTakeName != takeName ||
              this.playerTokenName != tokenName ||
              this.cardAsked != cardName)) {
        StreamController tokenController =
            getAppropriateController(this.listTurn[token]);
        Position takePosition = getApproPosition(this.listTurn[take]);
        Position tokenPosition = getApproPosition(this.listTurn[token]);
        animateCard(tokenController, tokenPosition, takePosition);
      } else if ((succ &&
          subject != "-1" &&
          cardName != null &&
          cardToken != -1 &&
          takeName != null &&
          tokenName == null &&
          takeName != this.playerTakeName)) {
        StreamController tokenController = this._deckController;
        Position takePosition = getApproPosition(this.listTurn[take]);
        Position tokenPosition = deckPos;
        animateCard(tokenController, tokenPosition, takePosition);
      }
      if (takeName != null) {
        this.playerTakeName = takeName;
      }
      if (token != null) {
        if (token != -1) {
          this.playerTokenName = tokenName;
        } else {
          this.playerTokenName = "deck";
        }
      }
      this.successTakeCard = succ;
      this.subjectAsked = subject;
//        if (cardToken != null && cardToken != -1) {
//          this.cardAsked = cardName;
//        } else {
//          this.cardAsked = null;
//        }
      this.cardAsked = cardName;

      this._turnController.add(this.turn);

      ///update my deck
      List<dynamic> nDeck = event.data()['deck'];
      //update if deck change
      if (nDeck == null) {
        nDeck = [];
      }
      List<int> newDeck = nDeck.cast<int>();
      this.deck.setCards(this.updateMyDeck(newDeck));

      ///update my turn
      dynamic turn = event.data()['turn'];
      if (turn == null) {
        this.turn = 0;
      }
      if (turn != this.turn) {
        this.turn = turn;
        this._turnController.add(this.turn);
        this._stringsOnDeckController.add(1);
      }
    });

    ///listen about changes in players cards and scores
    FirebaseFirestore.instance
        .collection("games")
        .doc(this.gameId)
        .collection("players")
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((element) {
        String playerId = element.doc.reference.id;
        List<dynamic> nCard = element.doc.data()['cards'];
        List<int> newCards;
        if (nCard != null) {
          newCards = nCard.cast<int>();
        } else {
          newCards = [];
        }
        dynamic score = element.doc.data()['score'];
        if (score == null) {
          score = 0;
        }
        // score = score.cast<int>();
        this.updatePlayerCards(newCards, playerId);
        this.updatePlayerScore(playerId, score);

        bool everyoneNoHaveCards = false;
        for (Player player in this.players) {
          if (player.isHaveCards()) {
            everyoneNoHaveCards = true;
            break;
          }
        }
        if (!this.deck.isEmpty()) {
          everyoneNoHaveCards = true;
        }
        if (!everyoneNoHaveCards) {
          this.isFinished = true;
          print("game need to done!");
          this._turnController.add(this.turn);
        }
        this._otherPlayersCardsController.add(1);
        this._otherPlayersCardsController.add(1);
        this._myCardsController.add(1);
        this._myScoreController.add(1);
      });
//        }
    });
  }

  Future<String> getNamePlayerTake() async {
    return this.listTurn[await GameDatabaseService().getTake(this)].name;
  }

  Future<String> getNamePlayerTokenFrom() async {
    return this.listTurn[await GameDatabaseService().getTokenFrom(this)].name;
  }

  Future<String> getStringCardToken() async {
    return this
        .idToCard(await GameDatabaseService().getCardToken(this))
        .english;
  }

  // void takeDataOfGame() async {
  //   Map<String, List<int>> playersCards = {};
  //   for (Player p in players) {
  //     playersCards[p.uid] = [];
  //     for (CardQuartets q in p.cards) {
  //       int x = this.cardsId[q];
  //       playersCards[p.uid].add(x);
  //     }
  //     //update server about the cards of the players
  //     print(p.uid);
  //     GameDatabaseService()
  //         .initializePlayerCard(playersCards[p.uid], this, p.uid);
  //   }
  //   this.deck.cards = await GameDatabaseService().getDeck(this);
  // }

  void createAllSubjects(String gameId) async {
    List<String> strSub =
        await GameDatabaseService().getGameListSubjects(gameId);

    // String subjectId = await GameDatabaseService().getSubjectsId(gameId);
    this.subjects.addAll(await getSubjectsFromStrings(strSub));
    createMap();
    return;
  }

  void createMap() {
    int z = 0;
    for (Subject sub in this.subjects) {
      for (CardQuartets card in sub.getCards()) {
        this.cardsId[card] = z;
        z++;
      }
    }
  }

  Future<List<Subject>> getSubjectsFromStrings(List<String> strSub) async {
    List<Subject> subs = [];
    String subjectId;
    bool isGenerics = await GameDatabaseService().getGenerics(gameId);
    if (isGenerics) {
      subjectId = "generic_subjects";
      print(subjectId);
    } else {
      subjectId = await GameDatabaseService().getManagerId(gameId);
    }
    for (String s in strSub) {
      Subject sub =
          await GameDatabaseService().createSubjectFromDatabase(subjectId, s);
      subs.add(sub);
    }
    return Future.value(subs);
  }

  /// manager create all the members and update the server.
  void reStart() async {
    Deck deck = createDeck(this.subjects);
    deck.handoutDeck(this.players);
    this.deck = deck;
    //initialize arrays with all the id cards to every player in the game.
    Map<String, List<int>> playersCards = {};
    for (Player p in players) {
      playersCards[p.uid] = [];
      for (CardQuartets q in p.cards) {
        int x = this.cardsId[q];
        playersCards[p.uid].add(x);
      }
      //update server about the cards of the players
      await GameDatabaseService()
          .initializePlayerCard(playersCards[p.uid], this, p.uid);
    }
    //update server about the deck
    List<int> deckCards = [];
    for (CardQuartets q in deck.getCards()) {
      int x = this.cardsId[q];
      deckCards.add(x);
    }
    var random = Random();
    this.turn = random.nextInt(this.listTurn.length);
    this._gameStart.add(true);
    await GameDatabaseService().updateTurn(this, this.turn);
    await GameDatabaseService().updateDeck(deckCards, this);
    await GameDatabaseService().updateContinueState(this.gameId);
  }

  void changeScoresOfPlayers() async {
    for (Player p in players) {
      GameDatabaseService().updateScore(0, p.uid, this);
    }
  }

  bool askPlayer(Player player, Subject subject) {
    for (CardQuartets card in player.cards) {
      if (card.getSubject() == subject.nameSubject) {
        return true;
      }
    }
    return false;
  }

  /// return Future with boolean: true if computer success take card from another player, otherwise - false.
  Future<bool> askByComputer(
      Player player, Subject subject, CardQuartets card) async {
    //ask card that not in the right subject.
    if (card.getSubject() != subject.nameSubject) {
      throw Exception("not appropriate card and subject!");
    }

    if (askPlayer(player, subject)) {
      // ask about a subject
      if (askPlayerSpecCard(player, subject, card) != null) {
        // ask about spec card.
        await takeCardFromPlayer(card, player);
        return new Future.delayed(const Duration(seconds: 5), () => true);
      } else {
        await takeCardFromDeck();
        return new Future.delayed(const Duration(seconds: 5), () => false);
      }
    } else {
      // didn't success take card from another player
      await takeCardFromDeck();

      return new Future.delayed(const Duration(seconds: 5), () => false);
    }
  }

  CardQuartets askPlayerSpecCard(
      Player player, Subject subject, CardQuartets cardQuartets) {
    for (CardQuartets card in player.cards) {
      if (card.getSubject() == subject.nameSubject && cardQuartets == card) {
        return card;
      }
    }
    return null;
  }

  void printSubjects() {
    for (Subject sub in this.subjects) {
      print("sub: " + sub.nameSubject);
    }
  }

  void printCardsInTheGame(List<CardQuartets> list) {
    for (CardQuartets card in list) {
      print("card: " + card.english + " in Subject: " + card.getSubject());
    }
  }

  void checkComputerPlayerTurn() {
    Player player = this.getPlayerNeedTurn();
    if (player is ComputerPlayer) {
      print("computer move!");
      player.makeMove(this);
    }
  }

  Player getPlayerByName(String name) {
    //TODO: if there are some players? I think that when they get in to check it and to add number, like shilo1 and shilo2.
    for (Player player in this.players) {
      if (name == player.name) {
        return player;
      }
    }
    return null;
  }

  List<String> getNamesPlayers() {
    List<String> names = [];
    for (Player player in this.players) {
      names.add(player.name);
    }
    return names;
  }

  void changeToNextPlayerTurn() {
    this.turn = (this.turn + 1) % this.players.length;
    this._turnController.add(this.turn);
    GameDatabaseService().updateTurn(this, this.turn);
  }

  // return true - if game done, false - otherwise.
  bool doneTurn() {
    Player player = getPlayerNeedTurn();
    removeAllSeriesDone(player);
    if (checkIfGameDone()) {
      return true;
    }
    changeToNextPlayerTurn();

    //update the text on the deck - view.
    this._stringsOnDeckController.add(1);
    checkComputerPlayerTurn();
    if (checkIfGameDone()) {
      return true;
    }
    return false;
  }

  bool checkIfGameDone() {
    if (this.deck.getCards().length == 0 && !isPlayersHasCards()) {
      GameDatabaseService().updateTurn(this, this.turn);
      //TODO: dispose everything
      return true;
    }
    return false;
  }

  bool isPlayersHasCards() {
    for (Player player in this.players) {
      if (player.cards.length > 0) {
        return true;
      }
    }
    return false;
  }

  Player getPlayerNeedTurn() {
    return this.listTurn.elementAt(this.turn);
  }

  void addToListTurn(Player p) {
    this.listTurn.add(p);
  }

  int getNumPlayers() {
    return this.players.length;
  }

  Player getFirstPlayer() {
    try {
      return this.players.elementAt(1);
    } catch (e) {
      throw new Exception("no player 1");
    }
  }

  Player getSecondPlayer() {
    if (this.players.length <= 2) {
      return null;
    }
    try {
      return this.players.elementAt(2);
    } catch (e) {
      throw new Exception("no player 2");
    }
  }

  Player getThirdPlayer() {
    if (this.players.length <= 3) {
      return null;
    }
    try {
      return this.players.elementAt(3);
    } catch (e) {
      throw new Exception("no player 3");
    }
  }

  Player getMyPlayer() {
    try {
      return this.players.elementAt(0);
    } catch (e) {
      throw new Exception("no player me at players[0]");
    }
  }

  Deck createDeck(List<Subject> subjects) {
    Deck deck = new Deck(subjects);
    return deck;

    // List<Subject> subs = mySubjects();
    // Deck deck = new Deck(subs);
    //
    // return deck;
  }
  //
  // List<Subject> mySubjects() {
  //   return [];
//     Subject furnitures = Subject(
//         "Furnitures",
//         Triple(
//             "table",
//             "שולחן",
//             Image(
//               image: AssetImage('images/table.jpg'),
//             )),
//         Triple(
//             "chair",
//             "כסא",
//             Image(
//               image: AssetImage('images/chair.jpg'),
//             )),
//         Triple(
//             "bed",
//             "מיטה",
//             Image(
//               image: AssetImage('images/bed.jpg'),
//             )),
//         Triple(
//             "cupboard",
//             "ארון",
//             Image(
//               image: AssetImage('images/cupboard.jpg'),
//             )));
//     Subject pets = Subject(
//         "Pets",
//         Triple(
//             "cat",
//             "חתול",
//             Image(
//               image: AssetImage('images/cat.jpg'),
//             )),
//         Triple(
//             "dog",
//             "כלב",
//             Image(
//               image: AssetImage('images/dog.jpg'),
//             )),
//         Triple(
//             "hamster",
//             "אוגר",
//             Image(
//               image: AssetImage('images/hamster.jpg'),
//             )),
//         Triple(
//             "fish",
//             "דג",
//             Image(
//               image: AssetImage('images/fish.jpg'),
//             )));
//     Subject days = Subject(
//         "Days",
//         Triple(
//             "sunday",
//             "יום ראשון",
//             Image(
//               image: AssetImage('images/sunday.png'),
//             )),
//         Triple(
//             "monday",
//             "יום שני",
//             Image(
//               image: AssetImage('images/monday.png'),
//             )),
//         Triple(
//             "saturday",
//             "יום שבת",
//             Image(
//               image: AssetImage('images/saturday.png'),
//             )),
//         Triple(
//             "friday",
//             "יום שישי",
//             Image(
//               image: AssetImage('images/friday.png'),
//             )));
//     Subject family = Subject(
//         "Family",
//         Triple(
//             "father",
//             "אבא",
//             Image(
//               image: AssetImage('images/father.png'),
//             )),
//         Triple(
//             "mother",
//             "אמא",
//             Image(
//               image: AssetImage('images/mother.jpg'),
//             )),
//         Triple(
//             "sister",
//             "אחות",
//             Image(
//               image: AssetImage('images/sister.jpg'),
//             )),
//         Triple(
//             "brother",
//             "אח",
//             Image(
//               image: AssetImage('images/brother.jpg'),
//             )));
//     Subject food = Subject(
//         "Food",
//         Triple(
//             "pizza",
//             "פיצה",
//             Image(
//               image: AssetImage('images/pizza.jpg'),
//             )),
//         Triple(
//             "rice",
//             "אורז",
//             Image(
//               image: AssetImage('images/rice.jpg'),
//             )),
//         Triple(
//             "meat",
//             "בשר",
//             Image(
//               image: AssetImage('images/meat.jpg'),
//             )),
//         Triple(
//             "soup",
//             "מרק",
//             Image(
//               image: AssetImage('images/soup.png'),
//             )));
//     Subject colors = Subject(
//         "Colors",
//         Triple("red", "אדום", null),
//         Triple("black", "שחור", null),
//         Triple("blue", "כחול", null),
//         Triple("green", "ירוק", null));
//     Subject musicalInstruments = Subject(
//         "Musical Instruments",
//         Triple("guitar", "גיטרה", null),
//         Triple("piano", "פסנתר", null),
//         Triple("flute", "חליל צד", null),
//         Triple("Ukulele", "יוקלילי", null));
//     Subject clothes = Subject(
//         "Clothes",
//         Triple("T-shirt", "חולצת-טי", null),
//         Triple("dress", "שמלה", null),
//         Triple("shoes", "נעליים", null),
//         Triple("skirt", "חצאית", null));
//
//     Subject days1 = Subject(
//         "Days1",
//         Triple(
//             "sunday",
//             "יום ראשון",
//             Image(
//               image: AssetImage('images/sunday.png'),
//             )),
//         Triple(
//             "monday",
//             "יום שני",
//             Image(
//               image: AssetImage('images/monday.png'),
//             )),
//         Triple(
//             "saturday",
//             "יום שבת",
//             Image(
//               image: AssetImage('images/saturday.png'),
//             )),
//         Triple(
//             "friday",
//             "יום שישי",
//             Image(
//               image: AssetImage('images/friday.png'),
//             )));
//     Subject family1 = Subject(
//         "Family1",
//         Triple(
//             "father",
//             "אבא",
//             Image(
//               image: AssetImage('images/father.png'),
//             )),
//         Triple(
//             "mother",
//             "אמא",
//             Image(
//               image: AssetImage('images/mother.jpg'),
//             )),
//         Triple(
//             "sister",
//             "אחות",
//             Image(
//               image: AssetImage('images/sister.jpg'),
//             )),
//         Triple(
//             "brother",
//             "אח",
//             Image(
//               image: AssetImage('images/brother.jpg'),
//             )));
//     Subject food1 = Subject(
//         "Food1",
//         Triple(
//             "pizza",
//             "פיצה",
//             Image(
//               image: AssetImage('images/pizza.jpg'),
//             )),
//         Triple(
//             "rice",
//             "אורז",
//             Image(
//               image: AssetImage('images/rice.jpg'),
//             )),
//         Triple(
//             "meat",
//             "בשר",
//             Image(
//               image: AssetImage('images/meat.jpg'),
//             )),
//         Triple(
//             "soup",
//             "מרק",
//             Image(
//               image: AssetImage('images/soup.png'),
//             )));
//     Subject days2 = Subject(
//         "Days2",
//         Triple(
//             "sunday",
//             "יום ראשון",
//             Image(
//               image: AssetImage('images/sunday.png'),
//             )),
//         Triple(
//             "monday",
//             "יום שני",
//             Image(
//               image: AssetImage('images/monday.png'),
//             )),
//         Triple(
//             "saturday",
//             "יום שבת",
//             Image(
//               image: AssetImage('images/saturday.png'),
//             )),
//         Triple(
//             "friday",
//             "יום שישי",
//             Image(
//               image: AssetImage('images/friday.png'),
//             )));
//     Subject family2 = Subject(
//         "Family2",
//         Triple(
//             "father",
//             "אבא",
//             Image(
//               image: AssetImage('images/father.png'),
//             )),
//         Triple(
//             "mother",
//             "אמא",
//             Image(
//               image: AssetImage('images/mother.jpg'),
//             )),
//         Triple(
//             "sister",
//             "אחות",
//             Image(
//               image: AssetImage('images/sister.jpg'),
//             )),
//         Triple(
//             "brother",
//             "אח",
//             Image(
//               image: AssetImage('images/brother.jpg'),
//             )));
//     Subject food2 = Subject(
//         "Food2",
//         Triple(
//             "pizza",
//             "פיצה",
//             Image(
//               image: AssetImage('images/pizza.jpg'),
//             )),
//         Triple(
//             "rice",
//             "אורז",
//             Image(
//               image: AssetImage('images/rice.jpg'),
//             )),
//         Triple(
//             "meat",
//             "בשר",
//             Image(
//               image: AssetImage('images/meat.jpg'),
//             )),
//         Triple(
//             "soup",
//             "מרק",
//             Image(
//               image: AssetImage('images/soup.png'),
//             )));
//     Subject days3 = Subject(
//         "Days3",
//         Triple(
//             "sunday",
//             "יום ראשון",
//             Image(
//               image: AssetImage('images/sunday.png'),
//             )),
//         Triple(
//             "monday",
//             "יום שני",
//             Image(
//               image: AssetImage('images/monday.png'),
//             )),
//         Triple(
//             "saturday",
//             "יום שבת",
//             Image(
//               image: AssetImage('images/saturday.png'),
//             )),
//         Triple(
//             "friday",
//             "יום שישי",
//             Image(
//               image: AssetImage('images/friday.png'),
//             )));
//     Subject family3 = Subject(
//         "Family3",
//         Triple(
//             "father",
//             "אבא",
//             Image(
//               image: AssetImage('images/father.png'),
//             )),
//         Triple(
//             "mother",
//             "אמא",
//             Image(
//               image: AssetImage('images/mother.jpg'),
//             )),
//         Triple(
//             "sister",
//             "אחות",
//             Image(
//               image: AssetImage('images/sister.jpg'),
//             )),
//         Triple(
//             "brother",
//             "אח",
//             Image(
//               image: AssetImage('images/brother.jpg'),
//             )));
//     Subject food3 = Subject(
//         "Food3",
//         Triple(
//             "pizza",
//             "פיצה",
//             Image(
//               image: AssetImage('images/pizza.jpg'),
//             )),
//         Triple(
//             "rice",
//             "אורז",
//             Image(
//               image: AssetImage('images/rice.jpg'),
//             )),
//         Triple(
//             "meat",
//             "בשר",
//             Image(
//               image: AssetImage('images/meat.jpg'),
//             )),
//         Triple(
//             "soup",
//             "מרק",
//             Image(
//               image: AssetImage('images/soup.png'),
//             )));
//     List<Subject> subs = [
//       furnitures,
//       pets,
//       days,
//       family,
//       food,
//       clothes,
//       colors,
//       musicalInstruments,
// //      days1,
// //      family1,
// //      food1,
// //      days2,
// //      family2,
// //      food2,
// //      days3,
// //      family3,
// //      food3
//     ];
//     return subs;
//   }

  Subject getSubjectByString(String sub) {
    for (Subject s in this.deck.getSubjects()) {
      if (s.nameSubject == sub) {
        return s;
      }
    }
    return null;
  }

  Future takeCardFromDeck() async {
    print("in deck before:");
    print(this.deck.getCards().length);
    //if no more cards in deck- enything happen.
    if (this.deck.getCards().length > 0) {
      Player player = getPlayerNeedTurn();
      print(player.name + " need to take card from deck!!");

      //animation:
      animateCard(this._deckController, deckPos, getApproPosition(player));
      await this.deck.giveCardToPlayer(player, this);

      // update tokens parameters.

      GameDatabaseService()
          .updateTake(this, this.listTurn.indexOf(player), -1, "", -1, true);

      //update view:
      this._myCardsController.add(1);
      this._otherPlayersCardsController.add(1);
      this._stringsOnDeckController.add(1);

      return Future.delayed(const Duration(seconds: 2));
    }
  }

  // this mathod is for the cards that need to move between the players and deck.
  void animateCard(
      StreamController sc, Position source, Position target) async {
    Position su = source;
    Position ta = target;
    // visible
    su.visible = true;
    sc.add(su);
    //move card
    ta.visible = true;
    sc.add(ta);
    await new Future.delayed(Duration(seconds: 2));

    //back animation to right place
    su.visible = false;
    sc.add(su);
//    await new Future.delayed(Duration(seconds: 2));
  }

  List<Subject> getSubjectsOfPlayer(Player player) {
    List<Subject> subjects = [];
    for (CardQuartets card in player.cards) {
      Subject subject = getSubjectByString(card.getSubject());
      if (!subjects.contains(subject)) {
        subjects.add(subject);
      }
    }
    return subjects;
  }

  bool isSubjectDone(Player player, Subject subject) {
    List<CardQuartets> cardsInSubject = subject.getCards();
    bool isDone = true;
    for (CardQuartets card in cardsInSubject) {
      if (!player.cards.contains(card)) {
        isDone = false;
        break;
      }
    }
    return isDone;
  }

  //get the series that found yet.
  List<Subject> seriesDone(Player player) {
    List<Subject> series = [];
    for (Subject subject in getSubjectsOfPlayer(player)) {
      if (isSubjectDone(player, subject)) {
        series.add(subject);
      }
    }
    return series;
  }

  int removeAllSeriesDone(Player player) {
    List<Subject> series = seriesDone(player);
    for (Subject subject in series) {
      GameDatabaseService().deleteQuartet(subject, this, player);
      player.raiseScore(10);
      GameDatabaseService().updateScore(player.score, player.uid, this);
      this._myScoreController.add(10);
      this._myCardsController.add(1);
      this._otherPlayersCardsController.add(1);
      this._turnController.add(1);
    }
    return series.length;
  }

  StreamController getAppropriateController(Player p) {
    if (p == getFirstPlayer()) {
      return this._firstController;
    } else if (p == getSecondPlayer()) {
      return this._secondController;
    } else if (p == getThirdPlayer()) {
      return this._thirdController;
    } else if (p == getMyPlayer()) {
      return this._meController;
    } else {
      throw Exception("need return controller of player but doesn't found it.");
    }
  }

  Future takeCardFromPlayer(CardQuartets card, Player tokenFrom) {
    Player player = getPlayerNeedTurn();
    if (!player.takeCardFromPlayer(card, tokenFrom)) {
      throw new Exception("error in take card");
    }
    //the token succeed, write the change to the document.
    GameDatabaseService().transferCard(player, tokenFrom, this, card);

    //update takes parameters in server.
    GameDatabaseService().updateTake(
        this,
        this.listTurn.indexOf(player),
        this.listTurn.indexOf(tokenFrom),
        card.getSubject(),
        this.cardsId[card],
        true);

    //animations:
    animateCard(getAppropriateController(tokenFrom),
        getApproPosition(tokenFrom), getApproPosition(player));
    this._myCardsController.add(1);
    this._otherPlayersCardsController.add(1);

    return new Future.delayed(const Duration(seconds: 2));
  }

  //this method is for asking someone in this return value.
  List<Player> getPlayersWithCardsWithoutMe(Player me) {
    List<Player> players = [];
    for (Player player in this.players) {
      if (player != me && player.cards.length > 0) {
        players.add(player);
      }
    }
    return players;
  }

  //for animations cards between players.
  Position getApproPosition(Player player) {
    if (getFirstPlayer() == player) {
      return firstPlayerPos;
    } else if (getSecondPlayer() == player) {
      return secondPlayerPos;
    } else if (getThirdPlayer() == player) {
      return thirdPlayerPos;
    } else if (getMyPlayer() == player) {
      return mePos;
    } else {
      throw Exception("didn't find appropriate player");
    }
  }

  /// update my deck member from the server.
  List<CardQuartets> updateMyDeck(List<int> nDeck) {
    List<CardQuartets> newDeckCards = [];
    for (var i in nDeck) {
      var key = this
          .cardsId
          .keys
          .firstWhere((k) => this.cardsId[k] == i, orElse: () => null);
      newDeckCards.add(key);
    }
    return newDeckCards;
  }

  void updatePlayerCards(List<int> cards, String id) {
    List<CardQuartets> newCardsList = [];
    for (var i in cards) {
      var key = this
          .cardsId
          .keys
          .firstWhere((k) => this.cardsId[k] == i, orElse: () => null);
      newCardsList.add(key);
    }
    for (Player p in this.players) {
      if (p.uid == id) {
        p.cards = newCardsList;
      }
      for (CardQuartets c in p.cards) {
        if (p is Me) {
          c.changeToMine();
        } else {
          c.changeToNotMine();
        }
      }
    }
  }

  void updatePlayerScore(String playerId, int score) {
    for (var i in this.players) {
      if (i.uid == playerId) {
        i.score = score;
      }
    }
  }

  CardQuartets idToCard(int id) {
    CardQuartets iKey = this
        .cardsId
        .keys
        .firstWhere((k) => this.cardsId[k] == id, orElse: () => null);
    return iKey;
  }

  Future speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
}
