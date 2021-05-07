import 'dart:async';
import 'package:engli_app/Constants.dart';
import 'package:engli_app/cards/CardMemory.dart';
import 'package:engli_app/cards/Pair.dart';
import 'package:engli_app/players/Player.dart';
import 'Game.dart';

class MemoryGame extends Game {
  List<Pair> pairs;
  StreamController _myScoreController;
  StreamController _enemyScoreController;
  StreamController _moreTurnController;
  StreamController _turnController;
  List<StreamController> controllers;
  List<Function> observers;
  bool computerEnemy;


  MemoryGame(bool computerEnemy, enemyName, StreamController myScore, StreamController enemyScore, StreamController moreTurn, StreamController turn) {
    //TODO: get my name !
    String meName = "need to get my name!";
this.computerEnemy = computerEnemy;
    this._myScoreController = myScore;
    this._enemyScoreController = enemyScore;
    this._moreTurnController = moreTurn;
    this._turnController = turn;
    this.controllers = [];
    this.players = [];
    this.pairs = [];
    this.observers = [];
    this.turn = 0;
    reStart(computerEnemy, meName, enemyName);
  }

  void reStart(bool computerEnemy, String meName, String enemyName) {
    Me me = createPlayer(true, meName, true);
    Other enemy = createPlayer(false, enemyName, computerEnemy);
    players.add(me);
    this.controllers.add(this._myScoreController);
    players.add(enemy);
    this.controllers.add(this._enemyScoreController);
    this.pairs = createPairs();
    setGameToPairs(pairs, this);
    this.turn = 0;
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

  void setGameToPairs(List<Pair> list, MemoryGame mg) {
    List<CardMemory> cards = getCardsFromPairs(list);
    for (CardMemory card in cards) {
      card.setGame(mg);
    }
  }

  Player createPlayer(bool isMe, String name, bool computerEnemy) {
    List<CardMemory> cards = [];
    if (isMe) {
      return Me(cards, name);
    } else {
      if (computerEnemy) {
        return ComputerPlayer(cards, name);
      } else {
        return VirtualPlayer(cards, name);
      }
    }
  }

  List<Pair> createPairs() {
    // TODO: insert here the cards that we get from the user.
    List<Pair> pairs = [];
    pairs.add(createPair("dog", "כלב"));
    pairs.add(createPair("cat", "חתול"));
    pairs.add(createPair("fish", "דג"));
    pairs.add(createPair("elephant", "פיל"));
    pairs.add(createPair("father", "אבא"));
    pairs.add(createPair("mother", "אמא"));
    pairs.add(createPair("brother", "אח"));
    pairs.add(createPair("Eden", "עדן"));
    pairs.add(createPair("Hila", "הלה"));
    pairs.add(createPair("Moriya", "מוריה"));
    pairs.add(createPair("Judith", "יהודית"));
    pairs.add(createPair("Hadas", "הדס"));
    pairs.add(createPair("Ora", "אורה"));
    pairs.add(createPair("Dvir", "דביר"));
    pairs.add(createPair("Shilo", "שילה"));

    pairs.shuffle();
    return pairs;
  }

  Pair createPair(String english, String hebrew) {
    return new Pair(
        CardMemory(english, hebrew, true, this.computerEnemy), CardMemory(english, hebrew, false, this.computerEnemy));
  }

  Player getPlayerNeedTurn(){
    return this.players[turn];
  }

  List<CardMemory> getCardsFromPairs(List<Pair> pairs) {
    List<CardMemory> cards = [];
    for (Pair pair in pairs) {
      cards.addAll(pair.getCards());
    }
    return cards;
  }

  void addPair(Pair pair) {
    this.pairs.add(pair);
  }

  void removePair(Pair pair) {
    this.pairs.remove(pair);
    checkIfGameDone();
  }

  bool checkIfGameDone() {
    if (this.pairs.length <= 0) {
      updateObservers();
      return true;
    }
    return false;
  }

  List<CardMemory> getCards() {
    List<CardMemory> list = [];
    for (Pair pair in this.pairs) {
      list.addAll(pair.getCards());
    }
    return list;
  }

  bool allowSwapCards() {
    List<CardMemory> chosens = [];
    for (CardMemory card in getCards()) {
      if (!card.isClose) {
        chosens.add(card);
      }
    }
    if (chosens.length >= 2 || this.players[this.turn] is ComputerPlayer) {
      return false;
    } else {
      return true;
    }
  }

  Pair isPair(CardMemory c1, CardMemory c2) {
    for (Pair pair in this.pairs) {
      if ((pair.c1 == c1 && pair.c2 == c2) ||
          (pair.c1 == c2 && pair.c2 == c1)) {
        return pair;
      }
    }
    return null;
  }

  Player getMe() {
    for (Player player in this.players) {
      if (player is Me) {
        return player;
      }
    }
  }

  Player getEnemy() {
    for (Player player in this.players) {
      if (player is Other) {
        return player;
      }
    }
  }

  void changeTurn() {
    print("change turn!!!");
    this.turn = (this.turn + 1) % this.players.length;
    this._turnController.add("change turn!");
  }

  void closeAllCards() {
    for (CardMemory card in getCards()) {
      if (!card.isClose) {
        card.isClose = true;
        card.updateObservers();
      }
    }
    print("close cards");
  }

  Future changeCardState(CardMemory card, bool isClose) {
    if (card.isClose != isClose) {
      print("turn card");
      card.isClose = isClose;
      card.updateObservers();
      return new Future.delayed(const Duration(seconds: 2));
    }
  }

  //return true if switch player turn, false - if its need to stay in his turn.
  bool checkOpenCards() {
    List<CardMemory> chosens = [];
    for (CardMemory card in getCards()) {
      if (!card.isClose) {
        chosens.add(card);
      }
    }
    if (chosens.length < 2) { return false;}
    else if (chosens.length == 2) {
      Pair pairChosen = isPair(chosens[0], chosens[1]);
      if (pairChosen != null) {
        removePair(pairChosen);
        this.controllers[this.turn].add(this.players[this.turn].raiseScore(howMuchScoreForSuccess));
        showMoreTurnWidget();
        return false;
      } else {
        closeAllCards();
      }
      changeTurn();
    } else { // chosens.length > 2
      closeAllCards();
    }
    return true;
  }

  void showMoreTurnWidget() async {
    this._moreTurnController.add("!עוד תור");
    await Future.delayed(Duration(seconds: 2));
    this._moreTurnController.add("");
  }

  void cardClicked(){
    if (checkOpenCards() && this.players[this.turn] is ComputerPlayer) {
      computerMove();
      return;
    } else {
      return;
    }
  }

  void computerMove() {
    print("computer turn");
    ComputerPlayer player = this.players[this.turn] as ComputerPlayer;
    print("computer need to move");
    player.makeMove(this);
  }

}
