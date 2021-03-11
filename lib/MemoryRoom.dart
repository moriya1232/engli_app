import 'dart:io';
import 'dart:math';
//import 'package:engli_app/MemoryGame/MemoryGame.dart';
import 'package:flutter/material.dart';
import 'cards/CardMemory.dart';
import 'cards/Pair.dart';
import 'players/player.dart';
import 'Constants.dart';

const int maxCards = 36;

class MemoryRoom extends StatefulWidget {
  MemoryGame game;
  MemoryRoom() {
    reStart();
  }
  @override
  _MemoryRoomState createState() => _MemoryRoomState();

  void reStart() {
    List<Player> players = [];
    Me me = createPlayer(true, memoryMe);
    Other enemy = createPlayer(false, memoryEnemy);
    players.add(me);
    players.add(enemy);
    List<Pair> pairs = createPairs();
    this.game = MemoryGame(players, pairs);
    setGameToPairs(pairs, this.game);
    //this.game.setRoom(this);
  }



  void setGameToPairs(List<Pair> list, MemoryGame mg) {
    List<CardMemory> cards = getCards(list);
    for (CardMemory card in cards) {
      card.setGame(mg);
    }
  }

  Player createPlayer(bool isMe, String name) {
    List<CardMemory> cards = [];
    if (isMe) {
      return Me(cards, name);
    } else {
      return Other(cards, name);
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
    pairs.add(createPair("sister", "אחות"));
    pairs.add(createPair("Eden", "עדן"));
    pairs.add(createPair("Hila", "הלה"));
    pairs.add(createPair("Moriya", "מוריה"));
    pairs.add(createPair("Judith", "יהודית"));
    pairs.add(createPair("Hadas", "הדס"));

    pairs.shuffle();
    return pairs;
  }

  Pair createPair(String english, String hebrew) {
    return new Pair(CardMemory(english, hebrew, true), CardMemory(english, hebrew, false));
  }

  List<CardMemory> getCards(List<Pair> pairs) {
    List<CardMemory> cards = [];
    for (Pair pair in pairs) {
      cards.addAll(pair.getCards());
    }
    return cards;
  }
}

class _MemoryRoomState extends State<MemoryRoom> {


  @override
  Widget build(BuildContext context) {
    return getDesign(context);
  }

  Widget getDesign(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('משחק זיכרון'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  height: 70,
                  child: Text('${widget.game.getEnemy().score} נקודות '),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createBoard(widget.game.pairs),
                ],
              ),
              Center(
                child: Container(
                  height: 70,
                  child: Text(':נקודות ${widget.game.getMe().score}'),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }


  Widget createBoard(List<Pair> pairs) {
    List<List<CardMemory>> columns = [];
    List<CardMemory> column = [];
    int howMuchCardsInColumn = sqrt(widget.getCards(pairs).length).round();
    int i = 0;
    for (CardMemory card in widget.getCards(pairs)) {
      if (i < howMuchCardsInColumn - 1) {
        column.add(card);
        i++;
      } else {
        i = 0;
        column.add(card);
        columns.add(column);
        column = [];
      }
    }
    if (column.isNotEmpty) {
      columns.add(column);
    }
    List<Widget> colsWidget = columns
        .map((col) => Column(
            children: col
                .map((card) => Container(
                      child: card,
                    ))
                .toList()))
        .toList();

    return Row(children: colsWidget);
  }
}

class MemoryGame{
  List<Player> players;
  List<Pair> pairs;
  int turn;
  //_MemoryRoomState room;

  MemoryGame(List<Player> p, List<Pair> pa) {
    this.players=p;
    this.pairs = pa;
    this.turn = 0;
  }

//  void setRoom(MemoryRoom mr) {
//    this.room = mr.createState();
//  }
//  void updateScreen(){
//    this.room.setState(() {
//
//    });
//    print("update");
//  }
  List<CardMemory> getCards() {
    List<CardMemory> list =[];
    for (Pair pair in this.pairs){
      list.addAll(pair.getCards());
    }
    return list;
  }

  void play() {
    while(this.pairs.length>0) {
      makeMove(this.players[this.turn]);

      //switch turn
      this.turn = (this.turn+1)%this.players.length;
      sleep(new Duration(seconds: 1));
    }
  }
  void makeMove(Player player) {

  }

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

  void closeAllCards() {
    for(Pair pair in this.pairs){
      for (CardMemory card in pair.getCards()){
        if (card.isClose == false) {
          //card.isClose = true;
          print("close card");
        }
      }
    }
  }

  void cardClicked(){
    List<CardMemory> chosens = [];
    for (CardMemory card in getCards()) {
      if (!card.isClose) {
        chosens.add(card);
      }
    }
    if (chosens.length == 2) {
      //sleep(new Duration(seconds: 2));
      Pair pairChosen = isPair(chosens[0], chosens[1]);
      if (pairChosen != null) {
        this.pairs.remove(pairChosen);
        print(this.pairs);
      }
      else {
        closeAllCards();
      }
    }
    //updateScreen();
  }
}
