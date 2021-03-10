import 'dart:math';
import 'package:engli_app/MemoryGame/MemoryGame.dart';
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
    for (int i = 0; i < 18; i++) {
      pairs.add(new Pair(CardMemory("english", "עברית", true), CardMemory("english1", "עברית1", false)));
    }
    pairs.shuffle();
    return pairs;
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
