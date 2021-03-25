import 'dart:math';
import 'file:///C:/Users/ASUS/AndroidStudioProjects/engli_app/lib/games/QuartetsGame.dart';
import 'package:engli_app/cards/CardMemory.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/games/Game.dart';
import 'package:engli_app/games/MemoryGame.dart';
import '../cards/CardGame.dart';

abstract class Player {
  List<CardGame> cards;
  String name;
  int score;
  List<Function> observers;

  Player(List<CardGame> cards, String name) {
    this.cards = cards;
    this.name = name;
    this.score = 0;
    this.observers = [];
  }

  void raiseScore(int howMuch) {
    this.score+=howMuch;
    updateObservers();
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

  void addCard(CardGame card) {
    this.cards.add(card);
  }

  List<String> getSubjects() {
    for (CardGame card in this.cards) {
      if (card is CardMemory){
        throw Exception("no subjects in memory cards.");
      }
    }
    List<String> subjects=[];
    for (CardQuartets card in this.cards){
      if(!subjects.contains(card.subject)) {
        subjects.add(card.subject);
      }
    }
    return subjects;
  }
}

class Me extends Player {
  Me(List<CardGame> cards, String name) : super(cards, name);
}

abstract class Other extends Player {
  Other(List<CardGame> cards, String name) : super(cards, name);
}

class ComputerPlayer extends Other {
  double rememberCance = 0.5;
  ComputerPlayer(List<CardGame> cards, String name) : super(cards, name);
  void changeRememberChance(double r) {
    this.rememberCance = r;
  }

  void makeMove(Game game) async{
    if (game is MemoryGame) {
      var random = Random();
      List<CardMemory> cards = game.getCards();
      var n1 = random.nextInt(cards.length);
      var n2 = random.nextInt(cards.length-1);
      if (n2 >= n1) n2 += 1;
      await game.changeCardState(cards[n1], false); //open card n1
      await game.changeCardState(cards[n2], false); // open card n2
      game.checkOpenCards();

      print("done computer turn");

    } else if (game is QuartetsGame) {

    }
  }
}

class VirtualPlayer extends Other {
  VirtualPlayer(List<CardGame> cards, String name) : super(cards, name);
}
