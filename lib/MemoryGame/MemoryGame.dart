//import 'dart:io';
import 'package:engli_app/Constants.dart';
import 'package:engli_app/cards/CardMemory.dart';
import 'package:engli_app/cards/Pair.dart';
import 'package:engli_app/players/player.dart';
import 'package:flutter/foundation.dart';



class MemoryGame extends ValueListenable{
  List<Function> observers;
  List<Player> players;
  List<Pair> pairs;
  int turn;


  MemoryGame(List<Player> p, List<Pair> pa) {
    this.players=p;
    this.pairs = pa;
    this.turn = 0;
    this.observers = new List<Function>();
  }

  void updateObservers() {
    for(Function f in this.observers) {
      f();
    }
  }

  void addPair(Pair pair) {
    this.pairs.add(pair);
    updateObservers();
  }

  void removePair(Pair pair) {
    this.pairs.remove(pair);
  }

  List<CardMemory> getCards() {
    List<CardMemory> list =[];
    for (Pair pair in this.pairs){
      list.addAll(pair.getCards());
    }
    return list;
  }
//
//  void play() {
//    while(this.pairs.length>0) {
//      makeMove(this.players[this.turn]);
//
//      //switch turn
//      this.turn = (this.turn+1)%this.players.length;
//      sleep(new Duration(seconds: 1));
//    }
//  }
//
//  void makeMove(Player player) {
//
//  }

  Pair isPair(CardMemory c1, CardMemory c2) {
    for (Pair pair in this.pairs) {
      if ((pair.c1 == c1 && pair.c2 == c2) || (pair.c1 == c2 && pair.c2 == c1)) {
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

  void changeTurn(){
    this.turn = (this.turn+1)%this.players.length;
  }

  void closeAllCards() {
    for (CardMemory card in getCards()){
      if(!card.isClose) {
        card.isClose = true;
        card.updateObservers();
      }
    }
    print("close cards");
  }


  void cardClicked(){
    List<CardMemory> chosens = [];
    for (CardMemory card in getCards()) {
      if (!card.isClose) {
        chosens.add(card);
      }
    }
    if (chosens.length == 2) {
      Pair pairChosen = isPair(chosens[0], chosens[1]);
      if (pairChosen != null) {
        removePair(pairChosen);
        this.players[this.turn].raiseScore(howMuchScoreForSuccess);
      }
      else {
        closeAllCards();
      }
      changeTurn();
    }
    if (chosens.length > 2) {
      closeAllCards();
    }


    updateObservers();
  }

  @override
  void addListener(listener) {
   this.observers.add(listener);
  }

  @override
  void removeListener(listener) {
    this.observers.remove(listener);
  }

  @override
  // TODO: implement value
  get value { return this.pairs;}
}