//import 'package:engli_app/MemoryRoom.dart';
import 'package:engli_app/cards/CardMemory.dart';
import 'package:engli_app/cards/CardQuartets.dart';


import '../cards/CardGame.dart';

class Player {
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

class Other extends Player {
  Other(List<CardGame> cards, String name) : super(cards, name);
}
