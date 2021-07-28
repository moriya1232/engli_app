import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/cards/Position.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/cards/Subject.dart';
import '../Constants.dart';
import 'Game.dart';

class QuartetsGame extends Game {
  Deck deck;
  String playerTakeName;
  String playerTokenName;
  String subjectAsked;
  String cardAsked;
  List<Subject> subjects;
  Map<CardQuartets, int> cardsId = {};
  bool isManager;
  String gameId;
  bool againstComputer = false;
  List<Player> listTurn = [];
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

  QuartetsGame(
      String gameId,
      bool isManager,
      List<Player> players,
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
      StreamController scStrings) {
    this.isManager = isManager;
    this.gameId = gameId;
    this.subjects = [];
    this.deck = new Deck(this.subjects);

    // this.cardsId = caID;
    this.playerTakeName = null;
    this.playerTokenName = null;
    this.subjectAsked = null;
    this.cardAsked = null;
    this.players = players;

    this._gameStart = gameStart;
    // controllers for animations.
    this._firstController = sc1;
    this._secondController = sc2;
    this._thirdController = sc3;
    this._meController = scMe;
    this._deckController = scDeck;

    this._turnController = scTurn;
    this._stringsOnDeckController = scStrings;

    this._myCardsController = myCards;
    this._myScoreController = myScore;
    this._otherPlayersCardsController = otherCards;
  }

  /// all the players (except the manager) create the game members
  void createGame() async {
    ///all players
    if (!this.againstComputer) {
      this.players = await GameDatabaseService().getPlayersList(this);
      print("List turn: ");
      for (Player p in this.listTurn) {
        print("name " + p.name);
      }
    }
    await createAllSubjects(gameId);

    /// only manager
    if (this.isManager) {
      await reStart();
      changeScoresOfPlayers();
    }
    if (!this.againstComputer) {
      ///listen to changes in specific game.
      FirebaseFirestore.instance
          .collection("games")
          .doc(this.gameId)
          .snapshots()
          .listen((event) {
        if (!this.isManager) {
          this._gameStart.add(true);
        }

        //update tokens parameters
        this.playerTakeName = this.listTurn[event.data()['take']].name;
        this.playerTokenName = this.listTurn[event.data()['tokenFrom']].name;
        CardQuartets card = this.idToCard(event.data()['cardToken']);
        if (card != null) {
          this.subjectAsked = card.subject;
          this.cardAsked = card.english;
        }

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

          this._otherPlayersCardsController.add(1);
          this._myCardsController.add(1);
          this._myScoreController.add(1);
        });
//        }
      });
    }
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

  Future<int> createAllSubjects(String gameId) async {
    int z = 0;
    List<String> strSub =
        await GameDatabaseService().getGameListSubjects(gameId);

    // String subjectId = await GameDatabaseService().getSubjectsId(gameId);
    for (String s in strSub) {
      Subject sub = await GameDatabaseService()
          .createSubjectFromDatabase("generic_subjects", s);
      this.subjects.add(sub);
      for (CardQuartets card in sub.getCards()) {
        this.cardsId[card] = z;
        z++;
      }
    }
    return Future.value(0);
  }

  /// manager create all the members and update the server.
  void reStart() async {
    //TODO: initialize cards in players hand.
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
    for (CardQuartets q in deck.cards) {
      int x = this.cardsId[q];
      deckCards.add(x);
    }
    //TODO: randomal turn.
    this.turn = 0;
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
      if (card.subject == subject.name_subject) {
        return true;
      }
    }
    return false;
  }

  /// return Future with boolean: true if computer success take card from another player, otherwise - false.
  Future<bool> askByComputer(
      Player player, Subject subject, CardQuartets card) async {
    //ask card that not in the right subject.
    if (card.subject != subject.name_subject) {
      throw Exception("not appropriate card and subject!");
    }

    if (askPlayerSpecCard(player, subject, card) != null) {
      //success take card from another player.
      // this.pl = player.name;
      this.subjectAsked = subject.name_subject;
      // ask subject that the player has.
      if (askPlayer(player, subject)) {
        this.cardAsked = card.english;
      }
      await takeCardFromPlayer(card, player);

      return new Future.delayed(const Duration(seconds: 5), () => true);
    } else {
      // didn't success take card from another player
      // this.nameAsked = player.name;
      this.subjectAsked = subject.name_subject;
      this.cardAsked = "";
      await takeCardFromDeck();

      return new Future.delayed(const Duration(seconds: 5), () => false);
    }
  }

  CardQuartets askPlayerSpecCard(
      Player player, Subject subject, CardQuartets cardQuartets) {
    for (CardQuartets card in player.cards) {
      if (card.subject == subject.name_subject && cardQuartets == card) {
        return card;
      }
    }
    return null;
  }

  void printSubjects() {
    for (Subject sub in this.subjects) {
      print("sub: " + sub.name_subject);
    }
  }

  void printCardsInTheGame(List<CardQuartets> list) {
    for (CardQuartets card in list) {
      print("card: " + card.english + " in Subject: " + card.subject);
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

  bool doneTurn() {
    Player player = getPlayerNeedTurn();
    removeAllSeriesDone(player);
    if (checkIfGameDone()) {
      //reStart();
      return true;
    }
    changeToNextPlayerTurn();

    //update the text on the deck - view.
    this._stringsOnDeckController.add(1);
    checkComputerPlayerTurn();
    if (checkIfGameDone()) {
      //reStart();

      return true;
    }
    return false;
  }

  bool checkIfGameDone() {
    if (this.deck.cards.length == 0 && !isPlayersHasCards()) {
//      this.updateObservers();
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

  // Player createPlayer(bool isMe, String name) {
  //   Player player;
  //   if (isMe) {
  //     player = Me([], name);
  //   } else {
  //     player = VirtualPlayer([], name);
  //   }
  //   this.players.add(player);
  //   return player;
  // }

  Subject getSubjectByString(String sub) {
    for (Subject s in this.deck.subjects) {
      if (s.name_subject == sub) {
        return s;
      }
    }
    return null;
  }

  Future takeCardFromDeck() async {
    //if no more cards in deck- enything happen.
    if (this.deck.cards.length > 0) {
      Player player = getPlayerNeedTurn();
      print(player.name + " need to take card from deck!!");

      //animation:
      animateCard(this._deckController, deckPos, getApproPosition(player));
      await this.deck.giveCardToPlayer(player, this);

      // update tokens parameters.
      GameDatabaseService().updateTake(this, this.listTurn.indexOf(player));
      GameDatabaseService().updateTokenFrom(this, -1);
      GameDatabaseService().updateCardToken(this, -1);

      //GameDatabaseService().updateDeck(cards, gameId);
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
    su.visible = true;
    sc.add(su);
    ta.visible = true;
    sc.add(ta);
    await new Future.delayed(Duration(seconds: 2));
    su.visible = false;
    sc.add(su);
//    await new Future.delayed(Duration(seconds: 2));
  }

  List<Subject> getSubjectsOfPlayer(Player player) {
    List<Subject> subjects = [];
    for (CardQuartets card in player.cards) {
      Subject subject = getSubjectByString(card.subject);
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
    GameDatabaseService().updateTake(this, this.listTurn.indexOf(player));
    GameDatabaseService()
        .updateTokenFrom(this, this.listTurn.indexOf(tokenFrom));
    GameDatabaseService().updateCardToken(this, this.cardsId[card]);

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
}
