import 'package:engli_app/QuartetsGame/Constants.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:flutter/material.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/cards/Subject.dart';
import 'Game.dart';

class QuartetsGame extends Game {
  List<Function> observers;
  Deck deck;
  String nameAsked;
  String subjectAsked;
  String cardAsked;

  //List<Subject> subjects;

  QuartetsGame() {
    this.nameAsked = null;
    this.subjectAsked = null;
    this.cardAsked = null;
    this.players = [];
    this.observers = [];
    reStart();
  }

  void reStart() {
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
  }

  bool askPlayer(Player player, Subject subject) {
    for (CardQuartets card in player.cards) {
      if (card.subject == subject.name_subject) {
        return true;
      }
    }
    return false;
  }

  Future<bool> askByComputer(
      Player player, Subject subject, CardQuartets card) async {
    if (card.subject != subject.name_subject) {
      throw Exception("not appropriate card and subject!");
    }

    if (askPlayerSpecCard(player, subject, card) != null) {
      //success take card from another player.
      this.nameAsked = player.name;
      this.subjectAsked = subject.name_subject;
      if (askPlayer(player, subject)) {
        this.cardAsked = card.english;
      }
      await takeCardFromPlayer(card, player);
      updateObservers();
      return new Future.delayed(const Duration(seconds: 5), () => true);
    } else {
      // didn't success take card from another player
      this.nameAsked = player.name;
      this.subjectAsked = subject.name_subject;
      this.cardAsked = "";
      takeCardFromDeck();
      updateObservers();
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

  void updateObservers() {
    for (Function f in this.observers) {
      f();
    }
  }

  void addListener(listener) {
    this.observers.add(listener);
  }

  void removeListener(listener) {
    this.observers.remove(listener);
  }

  Player getPlayerByName(String name) {
    //TODO: if there are some players?
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

  bool doneTurn() {
    Player player = getPlayerNeedTurn();
    removeAllSeriesDone(player);
    if (checkIfGameDone()) {
      reStart();
      updateObservers();
      return true;
    }
    this.turn = (this.turn + 1) % this.players.length;
    updateObservers();
    checkComputerPlayerTurn();
    if (checkIfGameDone()) {
      reStart();
      updateObservers();
      return true;
    }
    return false;
  }

  bool checkIfGameDone() {
    if (this.deck.cards.length == 0 && !isPlayersHasCards()) {
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
//    Subject days1 = Subject(
//        "Days",
//        Triple("sunday", "יום ראשון", Image(
//          image: AssetImage('images/sunday.png'),
//        )),
//        Triple("monday", "יום שני", Image(
//          image: AssetImage('images/monday.png'),
//        )),
//        Triple("saturday", "יום שבת", Image(
//          image: AssetImage('images/saturday.png'),
//        )),
//        Triple("friday", "יום שישי", Image(
//          image: AssetImage('images/friday.png'),
//        )));
//    Subject family1 = Subject(
//        "Family",
//        Triple("father", "אבא", Image(
//          image: AssetImage('images/father.png'),
//        )),
//        Triple("mother", "אמא", Image(
//          image: AssetImage('images/mother.jpg'),
//        )),
//        Triple("sister", "אחות", Image(
//          image: AssetImage('images/sister.jpg'),
//        )),
//        Triple("brother", "אח", Image(
//          image: AssetImage('images/brother.jpg'),
//        )));
//    Subject food1 = Subject(
//        "Food",
//        Triple("pizza", "פיצה", Image(
//          image: AssetImage('images/pizza.jpg'),
//        )),
//        Triple("rice", "אורז", Image(
//          image: AssetImage('images/rice.jpg'),
//        )),
//        Triple("meat", "בשר", Image(
//          image: AssetImage('images/meat.jpg'),
//        )),
//        Triple("soup", "מרק", Image(
//          image: AssetImage('images/soup.png'),
//        )));
//    Subject days2 = Subject(
//        "Days",
//        Triple("sunday", "יום ראשון", Image(
//          image: AssetImage('images/sunday.png'),
//        )),
//        Triple("monday", "יום שני", Image(
//          image: AssetImage('images/monday.png'),
//        )),
//        Triple("saturday", "יום שבת", Image(
//          image: AssetImage('images/saturday.png'),
//        )),
//        Triple("friday", "יום שישי", Image(
//          image: AssetImage('images/friday.png'),
//        )));
//    Subject family2 = Subject(
//        "Family",
//        Triple("father", "אבא", Image(
//          image: AssetImage('images/father.png'),
//        )),
//        Triple("mother", "אמא", Image(
//          image: AssetImage('images/mother.jpg'),
//        )),
//        Triple("sister", "אחות", Image(
//          image: AssetImage('images/sister.jpg'),
//        )),
//        Triple("brother", "אח", Image(
//          image: AssetImage('images/brother.jpg'),
//        )));
//    Subject food2 = Subject(
//        "Food",
//        Triple("pizza", "פיצה", Image(
//          image: AssetImage('images/pizza.jpg'),
//        )),
//        Triple("rice", "אורז", Image(
//          image: AssetImage('images/rice.jpg'),
//        )),
//        Triple("meat", "בשר", Image(
//          image: AssetImage('images/meat.jpg'),
//        )),
//        Triple("soup", "מרק", Image(
//          image: AssetImage('images/soup.png'),
//        )));
//    Subject days3 = Subject(
//        "Days",
//        Triple("sunday", "יום ראשון", Image(
//          image: AssetImage('images/sunday.png'),
//        )),
//        Triple("monday", "יום שני", Image(
//          image: AssetImage('images/monday.png'),
//        )),
//        Triple("saturday", "יום שבת", Image(
//          image: AssetImage('images/saturday.png'),
//        )),
//        Triple("friday", "יום שישי", Image(
//          image: AssetImage('images/friday.png'),
//        )));
//    Subject family3 = Subject(
//        "Family",
//        Triple("father", "אבא", Image(
//          image: AssetImage('images/father.png'),
//        )),
//        Triple("mother", "אמא", Image(
//          image: AssetImage('images/mother.jpg'),
//        )),
//        Triple("sister", "אחות", Image(
//          image: AssetImage('images/sister.jpg'),
//        )),
//        Triple("brother", "אח", Image(
//          image: AssetImage('images/brother.jpg'),
//        )));
//    Subject food3 = Subject(
//        "Food",
//        Triple("pizza", "פיצה", Image(
//          image: AssetImage('images/pizza.jpg'),
//        )),
//        Triple("rice", "אורז", Image(
//          image: AssetImage('images/rice.jpg'),
//        )),
//        Triple("meat", "בשר", Image(
//          image: AssetImage('images/meat.jpg'),
//        )),
//        Triple("soup", "מרק", Image(
//          image: AssetImage('images/soup.png'),
//        )));
//    List<Subject> subs = [furnitures, pets, days, family, food,days1, family1, food1,days2, family2, food2,days3, family3, food3];
    List<Subject> subs = [furnitures, pets, days, family, food];
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
//    List<CardQuartets> cards = [
//      CardQuartets(
//          "table",
//          "שולחן",
//          Image(
//            image: AssetImage('images/table.jpg'),
//          ),
//          "Furniture",
//          "chair",
//          "cupboard",
//          "bed",
//          isMe),
//      CardQuartets(
//          "chair",
//          "כסא",
//          Image(
//            image: AssetImage('images/chair.jpg'),
//          ),
//          "Furniture",
//          "table",
//          "cupboard",
//          "bed",
//          isMe),
//      CardQuartets(
//          "bed",
//          "מיטה",
//          Image(
//            image: AssetImage('images/bed.jpg'),
//          ),
//          "Furniture",
//          "chair",
//          "cupboard",
//          "table",
//          isMe),
//      CardQuartets(
//          "cupboard",
//          "ארון",
//          Image(
//            image: AssetImage('images/cupboard.jpg'),
//          ),
//          "Furniture",
//          "chair",
//          "table",
//          "bed",
//          isMe),
//    ];
//    if (isMe) {
//      cards.add(CardQuartets(
//          "cat",
//          "חתול",
//          Image(
//            image: AssetImage('images/cat.jpg'),
//          ),
//          "Pets",
//          "dog",
//          "fish",
//          "hamster",
//          isMe),);
//      cards.add(CardQuartets(
//          "dog",
//          "כלב",
//          Image(
//            image: AssetImage('images/dog.jpg'),
//          ),
//          "Pets",
//          "cat",
//          "fish",
//          "hamster",
//          isMe),);
//      cards.add(CardQuartets(
//          "hamster",
//          "אוגר",
//          Image(
//            image: AssetImage('images/hamster.jpg'),
//          ),
//          "Pets",
//          "dog",
//          "fish",
//          "cat",
//          isMe),);
//      cards.add(CardQuartets(
//          "fish",
//          "דג",
//          Image(
//            image: AssetImage('images/cat.jpg'),
//          ),
//          "Pets",
//          "dog",
//          "cat",
//          "hamster",
//          isMe),);
//
//      return Me(cards);
//    } else {
//      return Other(cards);
//    }
  }

  Subject getSubjectByString(String sub) {
    for (Subject s in this.deck.subjects) {
      if (s.name_subject == sub) {
        return s;
      }
    }
    return null;
  }

  void takeCardFromDeck() async{
    if(this.deck.cards.length > 0) {
      await this.deck.giveCardToPlayer(getPlayerNeedTurn());
      this.updateObservers();
    }
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

  Future takeCardFromPlayer(CardQuartets card, Player tokenFrom) {
    if (!getPlayerNeedTurn().takeCardFromPlayer(card, tokenFrom)) {
      throw new Exception("error in take card");
    }
    return new Future.delayed(const Duration(seconds: 2));
  }

  List<Player> getPlayersWithCardWithoutMe(Player me) {
    List<Player> players = [];
    for (Player player in this.players) {
      if (player != me && player.cards.length > 0) {
        players.add(player);
      }
    }
    return players;
  }
}
