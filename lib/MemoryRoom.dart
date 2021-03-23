//import 'dart:io';
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

  MemoryRoom(){
    reStart();
  }

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
    return new Pair(CardMemory(english, hebrew, true), CardMemory(english, hebrew, false));
  }

  List<CardMemory> getCards(List<Pair> pairs) {
    List<CardMemory> cards = [];
    for (Pair pair in pairs) {
      cards.addAll(pair.getCards());
    }
    return cards;
  }

  @override
  _MemoryRoomState createState() => _MemoryRoomState();
}

class _MemoryRoomState extends State<MemoryRoom> {

  List<List<CardMemory>> columns = [];
  int howMuchCardsInColumn = 0;


  @override
  Widget build(BuildContext context) {
    return getDesign(context);
  }
  void _listener() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_listener);
    this.howMuchCardsInColumn = sqrt(widget.getCards(widget.game.pairs).length).round();
    initializeBoard();
  }

  @override
  void dispose() {
    widget.game.removeListener(_listener);
    super.dispose();
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
                  drawBoard(),
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

  void initializeBoard(){
    List<CardMemory> column = [];
    int i = 0;
    List<CardMemory> cards = widget.getCards(widget.game.pairs);
    cards.shuffle();
    for (CardMemory card in cards) {
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
  }

  Widget drawBoard() {
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

