

//import 'dart:io';
//
//import 'package:engli_app/MemoryRoom.dart';
//import 'package:engli_app/cards/CardMemory.dart';
//import 'package:engli_app/cards/Pair.dart';
//import 'package:engli_app/players/player.dart';
//import 'package:flutter/cupertino.dart';


//class MemoryGame{
//  List<Player> players;
//  List<Pair> pairs;
//  int turn;
//  MemoryRoom room;
//
//  MemoryGame(List<Player> p, List<Pair> pa) {
//    this.players=p;
//    this.pairs = pa;
//    this.turn = 0;
//  }
//
//  void setRoom(MemoryRoom mr) {
//    this.room = mr;
//  }
//  void updateScreen(){
//    this.room.createState();
//    print("update");
//  }
//  List<CardMemory> getCards() {
//    List<CardMemory> list =[];
//    for (Pair pair in this.pairs){
//      list.addAll(pair.getCards());
//    }
//    return list;
//  }
//
//  void play() {
//    while(this.pairs.length>0) {
//      makeMove(this.players[this.turn]);
//
//      //switch turn
//     this.turn = (this.turn+1)%this.players.length;
//     sleep(new Duration(seconds: 1));
//    }
//  }
//  void makeMove(Player player) {
//
//  }
//
//  Pair isPair(CardMemory c1, CardMemory c2) {
//    for (Pair pair in this.pairs) {
//      if ((pair.c1 == c1 && pair.c2 == c2) || (pair.c1 == c2 && pair.c2 == c1)) {
//        return pair;
//      }
//    }
//    return null;
//  }
//
//  Player getMe() {
//    for (Player player in this.players) {
//      if (player is Me) {
//        return player;
//      }
//    }
//  }
//
//  Player getEnemy() {
//    for (Player player in this.players) {
//      if (player is Other) {
//        return player;
//      }
//    }
//  }
//
//  void closeAllCards() {
//    for(Pair pair in this.pairs){
//      for (CardMemory card in pair.getCards()){
//        if (card.isClose == false) {
//          //card.isClose = true;
//          print("close card");
//        }
//      }
//    }
//  }
//
//  void cardClicked(){
//    List<CardMemory> chosens = [];
//    for (CardMemory card in getCards()) {
//      if (!card.isClose) {
//        chosens.add(card);
//      }
//    }
//    if (chosens.length == 2) {
//      //sleep(new Duration(seconds: 2));
//      Pair pairChosen = isPair(chosens[0], chosens[1]);
//      if (pairChosen != null) {
//        this.pairs.remove(pairChosen);
//        print(this.pairs);
//      }
//      else {
//        closeAllCards();
//      }
//    }
//    updateScreen();
//  }
//
//}