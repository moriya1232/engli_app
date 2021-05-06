import 'dart:async';

import 'package:engli_app/QuartetsGame/Constants.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:engli_app/cards/Position.dart';
import 'package:flutter/material.dart';
import 'package:engli_app/players/Player.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/cards/Subject.dart';
import '../Constants.dart';
import 'Game.dart';

class QuartetsGame extends Game {
  Deck deck;
  String nameAsked;
  String subjectAsked;
  String cardAsked;
  List<Function> observers;

  // controllers for animate the view.
  StreamController _firstController;
  StreamController _secondController;
  StreamController _thirdController;
  StreamController _meController;
  StreamController _deckController;
  StreamController _turnController;
  StreamController _myCardsController;
  StreamController _otherPlayersCardsController;
  StreamController _stringsOnDeckController;

  QuartetsGame(StreamController sc1, StreamController sc2, StreamController sc3,
      StreamController scMe, StreamController scDeck, StreamController scTurn, StreamController myCards, StreamController otherCards, StreamController scStrings) {
    this.nameAsked = null;
    this.subjectAsked = null;
    this.cardAsked = null;
    this.players = [];
    this.observers = [];

    // controllers for animations.
    this._firstController = sc1;
    this._secondController = sc2;
    this._thirdController = sc3;
    this._meController = scMe;
    this._deckController = scDeck;

    this._turnController = scTurn;
    this._stringsOnDeckController = scStrings;

    this._myCardsController=myCards;
    this._otherPlayersCardsController=otherCards;
    reStart();
  }
    void addListener(listener) {
    this.observers.add(listener);
  }

  void removeListener(listener) {
    this.observers.remove(listener);
  }

  void updateObservers() {
    for(Function f in this.observers) {
      f();
    }
  }

  void reStart() {

    // create players.
    for (int i = 0; i < playersNames.length + 1; i++) {
      if (i == 0) {
        createPlayer(true, quartetsMe);
        continue;
      }
      createPlayer(false, playersNames[i - 1]);
    }

    Deck deck = createDeck();
    deck.handoutDeck(this.players);
    this.deck = deck;
    this.turn = 0;

    //todo: check it! for replace "checkComputerPlayerTurn" to call by turnController
//    this._turnController.onListen(
//
//    );
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
      this.nameAsked = player.name;
      this.subjectAsked = subject.name_subject;
      // ask subject that the player has.
      if (askPlayer(player, subject)) {
        this.cardAsked = card.english;
      }
      await takeCardFromPlayer(card, player);

      return new Future.delayed(const Duration(seconds: 5), () => true);
    } else {
      // didn't success take card from another player
      this.nameAsked = player.name;
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

  void checkComputerPlayerTurn() {
    Player player = this.getPlayerNeedTurn();
    if (player is ComputerPlayer) {
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

  void changeToNextPlayerTurn(){
    this.turn = (this.turn + 1) % this.players.length;
    this._turnController.add(this.turn);
  }

  bool doneTurn() {
    Player player = getPlayerNeedTurn();
    removeAllSeriesDone(player);
    if (checkIfGameDone()) {
      reStart();
      return true;
    }
    changeToNextPlayerTurn();

    //update the text on the deck - view.
    this._stringsOnDeckController.add(1);
    checkComputerPlayerTurn();
    if (checkIfGameDone()) {
      reStart();

      return true;
    }
    return false;
  }

  bool checkIfGameDone() {
    if (this.deck.cards.length == 0 && !isPlayersHasCards()) {
      this.updateObservers();
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
    return this.players.elementAt(this.turn);
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
    try {
      return this.players.elementAt(2);
    } catch (e) {
      throw new Exception("no player 2");
    }
  }

  Player getThirdPlayer() {
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

  Deck createDeck() {
    //TODO: replace it! -- load deck from database
    Subject furnitures = Subject(
        "Furnitures",
        Triple(
            "table",
            "שולחן",
            Image(
              image: AssetImage('images/table.jpg'),
            )),
        Triple(
            "chair",
            "כסא",
            Image(
              image: AssetImage('images/chair.jpg'),
            )),
        Triple(
            "bed",
            "מיטה",
            Image(
              image: AssetImage('images/bed.jpg'),
            )),
        Triple(
            "cupboard",
            "ארון",
            Image(
              image: AssetImage('images/cupboard.jpg'),
            )));
    Subject pets = Subject(
        "Pets",
        Triple(
            "cat",
            "חתול",
            Image(
              image: AssetImage('images/cat.jpg'),
            )),
        Triple(
            "dog",
            "כלב",
            Image(
              image: AssetImage('images/dog.jpg'),
            )),
        Triple(
            "hamster",
            "אוגר",
            Image(
              image: AssetImage('images/hamster.jpg'),
            )),
        Triple(
            "fish",
            "דג",
            Image(
              image: AssetImage('images/fish.jpg'),
            )));
    Subject days = Subject(
        "Days",
        Triple(
            "sunday",
            "יום ראשון",
            Image(
              image: AssetImage('images/sunday.png'),
            )),
        Triple(
            "monday",
            "יום שני",
            Image(
              image: AssetImage('images/monday.png'),
            )),
        Triple(
            "saturday",
            "יום שבת",
            Image(
              image: AssetImage('images/saturday.png'),
            )),
        Triple(
            "friday",
            "יום שישי",
            Image(
              image: AssetImage('images/friday.png'),
            )));
    Subject family = Subject(
        "Family",
        Triple(
            "father",
            "אבא",
            Image(
              image: AssetImage('images/father.png'),
            )),
        Triple(
            "mother",
            "אמא",
            Image(
              image: AssetImage('images/mother.jpg'),
            )),
        Triple(
            "sister",
            "אחות",
            Image(
              image: AssetImage('images/sister.jpg'),
            )),
        Triple(
            "brother",
            "אח",
            Image(
              image: AssetImage('images/brother.jpg'),
            )));
    Subject food = Subject(
        "Food",
        Triple(
            "pizza",
            "פיצה",
            Image(
              image: AssetImage('images/pizza.jpg'),
            )),
        Triple(
            "rice",
            "אורז",
            Image(
              image: AssetImage('images/rice.jpg'),
            )),
        Triple(
            "meat",
            "בשר",
            Image(
              image: AssetImage('images/meat.jpg'),
            )),
        Triple(
            "soup",
            "מרק",
            Image(
              image: AssetImage('images/soup.png'),
            )));
    Subject days1 = Subject(
        "Days1",
        Triple(
            "sunday",
            "יום ראשון",
            Image(
              image: AssetImage('images/sunday.png'),
            )),
        Triple(
            "monday",
            "יום שני",
            Image(
              image: AssetImage('images/monday.png'),
            )),
        Triple(
            "saturday",
            "יום שבת",
            Image(
              image: AssetImage('images/saturday.png'),
            )),
        Triple(
            "friday",
            "יום שישי",
            Image(
              image: AssetImage('images/friday.png'),
            )));
    Subject family1 = Subject(
        "Family1",
        Triple(
            "father",
            "אבא",
            Image(
              image: AssetImage('images/father.png'),
            )),
        Triple(
            "mother",
            "אמא",
            Image(
              image: AssetImage('images/mother.jpg'),
            )),
        Triple(
            "sister",
            "אחות",
            Image(
              image: AssetImage('images/sister.jpg'),
            )),
        Triple(
            "brother",
            "אח",
            Image(
              image: AssetImage('images/brother.jpg'),
            )));
    Subject food1 = Subject(
        "Food1",
        Triple(
            "pizza",
            "פיצה",
            Image(
              image: AssetImage('images/pizza.jpg'),
            )),
        Triple(
            "rice",
            "אורז",
            Image(
              image: AssetImage('images/rice.jpg'),
            )),
        Triple(
            "meat",
            "בשר",
            Image(
              image: AssetImage('images/meat.jpg'),
            )),
        Triple(
            "soup",
            "מרק",
            Image(
              image: AssetImage('images/soup.png'),
            )));
    Subject days2 = Subject(
        "Days2",
        Triple(
            "sunday",
            "יום ראשון",
            Image(
              image: AssetImage('images/sunday.png'),
            )),
        Triple(
            "monday",
            "יום שני",
            Image(
              image: AssetImage('images/monday.png'),
            )),
        Triple(
            "saturday",
            "יום שבת",
            Image(
              image: AssetImage('images/saturday.png'),
            )),
        Triple(
            "friday",
            "יום שישי",
            Image(
              image: AssetImage('images/friday.png'),
            )));
    Subject family2 = Subject(
        "Family2",
        Triple(
            "father",
            "אבא",
            Image(
              image: AssetImage('images/father.png'),
            )),
        Triple(
            "mother",
            "אמא",
            Image(
              image: AssetImage('images/mother.jpg'),
            )),
        Triple(
            "sister",
            "אחות",
            Image(
              image: AssetImage('images/sister.jpg'),
            )),
        Triple(
            "brother",
            "אח",
            Image(
              image: AssetImage('images/brother.jpg'),
            )));
    Subject food2 = Subject(
        "Food2",
        Triple(
            "pizza",
            "פיצה",
            Image(
              image: AssetImage('images/pizza.jpg'),
            )),
        Triple(
            "rice",
            "אורז",
            Image(
              image: AssetImage('images/rice.jpg'),
            )),
        Triple(
            "meat",
            "בשר",
            Image(
              image: AssetImage('images/meat.jpg'),
            )),
        Triple(
            "soup",
            "מרק",
            Image(
              image: AssetImage('images/soup.png'),
            )));
    Subject days3 = Subject(
        "Days3",
        Triple(
            "sunday",
            "יום ראשון",
            Image(
              image: AssetImage('images/sunday.png'),
            )),
        Triple(
            "monday",
            "יום שני",
            Image(
              image: AssetImage('images/monday.png'),
            )),
        Triple(
            "saturday",
            "יום שבת",
            Image(
              image: AssetImage('images/saturday.png'),
            )),
        Triple(
            "friday",
            "יום שישי",
            Image(
              image: AssetImage('images/friday.png'),
            )));
    Subject family3 = Subject(
        "Family3",
        Triple(
            "father",
            "אבא",
            Image(
              image: AssetImage('images/father.png'),
            )),
        Triple(
            "mother",
            "אמא",
            Image(
              image: AssetImage('images/mother.jpg'),
            )),
        Triple(
            "sister",
            "אחות",
            Image(
              image: AssetImage('images/sister.jpg'),
            )),
        Triple(
            "brother",
            "אח",
            Image(
              image: AssetImage('images/brother.jpg'),
            )));
    Subject food3 = Subject(
        "Food3",
        Triple(
            "pizza",
            "פיצה",
            Image(
              image: AssetImage('images/pizza.jpg'),
            )),
        Triple(
            "rice",
            "אורז",
            Image(
              image: AssetImage('images/rice.jpg'),
            )),
        Triple(
            "meat",
            "בשר",
            Image(
              image: AssetImage('images/meat.jpg'),
            )),
        Triple(
            "soup",
            "מרק",
            Image(
              image: AssetImage('images/soup.png'),
            )));
    List<Subject> subs = [
      furnitures,
      pets,
      days,
      family,
      food,
      days1,
      family1,
      food1,
      days2,
      family2,
      food2,
      days3,
      family3,
      food3
    ];
//    List<Subject> subs = [furnitures, pets, days, family, food];
    Deck deck = new Deck(subs);
    return deck;
  }

  Player createPlayer(bool isMe, String name) {
    Player player;
    if (isMe) {
      player = Me([], name);
    } else {
      player = ComputerPlayer([], name);
    }
    this.players.add(player);
    return player;
  }

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

      //animations:
      animateCard(this._deckController, deckPos, player);
      this._myCardsController.add(1);
      this._otherPlayersCardsController.add(1);
      this._stringsOnDeckController.add(1);

      await this.deck.giveCardToPlayer(player);
      return Future.delayed(const Duration(seconds: 2));
    }
  }

  // this mathod is for the cards that need to move between the players and deck.
  void animateCard(
      StreamController sc, Position source, Player playerGiveToHim) async {
    //todo: arrange animations! - doesnt work well :(
    Position p = source;
    p.visible = true;
    sc.add(p);
    await new Future.delayed(Duration(seconds: 2));

    p = getApproPosition(playerGiveToHim);
    sc.add(p);
    await new Future.delayed(Duration(seconds: 2));

    p.visible = false;
    p = source;
    sc.add(p);
    await new Future.delayed(Duration(seconds: 2));
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
      for (CardQuartets card in subject.getCards()) {
        try {
          player.cards.remove(card);
        } catch (e) {
          throw new Exception("remove card that not in player's cards.");
        }
      }
      player.raiseScore(10);
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
      throw Exception("need return controller of player but doesnt found it.");
    }
  }

  Future takeCardFromPlayer(CardQuartets card, Player tokenFrom) {
    Player player = getPlayerNeedTurn();
    if (!player.takeCardFromPlayer(card, tokenFrom)) {
      throw new Exception("error in take card");
    }

    //animations:
    animateCard(getAppropriateController(tokenFrom),
        getApproPosition(tokenFrom), player);
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
}
