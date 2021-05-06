import 'dart:async';
import 'dart:math';
import 'package:engli_app/WinnerScreen.dart';
import 'package:flutter/material.dart';
import 'cards/CardMemory.dart';
import 'games/MemoryGame.dart';


const int maxCards = 36;

//TODO: play against other virtual players.

class MemoryRoom extends StatefulWidget {
  final _streamControllerMyScore = StreamController<int>.broadcast();
  final _streamControllerEnemyScore = StreamController<int>.broadcast();

  MemoryGame game;
  bool computerEnemy;
  String enemyName = "";


  MemoryRoom(bool computerEnemy, String en) {
    this.computerEnemy = computerEnemy;
    this.game = new MemoryGame(computerEnemy, en, this._streamControllerMyScore, this._streamControllerEnemyScore);
    this.enemyName = en;
  }

  @override
  _MemoryRoomState createState() => _MemoryRoomState();
}

class _MemoryRoomState extends State<MemoryRoom> {
  List<List<CardMemory>> columns = [];
  int howMuchCardsInColumn = 0;



  @override
  Widget build(BuildContext context) {
//    if (widget.game.pairs.isNotEmpty) {
      return getDesign(context);
//    } else {
//      goToWinnerScreen();
//      widget.game = new MemoryGame(widget.computerEnemy, this.widget.enemyName, this.widget._streamControllerMyScore, this.widget._streamControllerEnemyScore);
//      return getDesign(context);
//    }
  }

  void _listener() {
//    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WinnerScreen(this.widget.game)),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_listener);
//    for (Player player in widget.game.players) {
//      player.addListener(_listener);
//    }
    this.howMuchCardsInColumn =
        sqrt(widget.game.getCards().length).round();
    initializeBoard();
  }

  @override
  void dispose() {
    widget.game.removeListener(_listener);
//    for (Player player in widget.game.players) {
//      player.removeListener(_listener);
//    }
    this.widget._streamControllerMyScore.close();
    this.widget._streamControllerEnemyScore.close();

    super.dispose();
  }

  Widget getDesign(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height/30;
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Center(
                  child: Text(
                    ' ${widget.game.getEnemy().name}',
                    style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: fontSize,
                        fontFamily: 'Gan-h'),
                  ),
                ),
              ),
              Center(
                child: StreamBuilder<int>(
                    stream: this.widget._streamControllerEnemyScore.stream,
                    builder: (context, snapshot) {
                      return Text(
                        ' נקודות: ${widget.game.getEnemy().score}',
                        style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: fontSize,
                            fontFamily: 'Abraham-h'),
                      ); } ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  drawBoard(),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Center(
                  child: Text(
                    ' ${widget.game.getMe().name}',
                    style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: fontSize,
                        fontFamily: 'Gan-h'),
                  ),
                ),
              ),
              Center(
                child: StreamBuilder<int>(
                    stream: this.widget._streamControllerMyScore.stream,
                    builder: (context, snapshot) {
                      return Text(
                        ' נקודות: ${widget.game.getMe().score}',
                        style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: fontSize,
                            fontFamily: 'Abraham-h'),
                      ); }
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      ' תור: ${widget.game.players[widget.game.turn].name}',
                      style: TextStyle(
                          color: Colors.pink,
                          fontSize: fontSize,
                          fontFamily: 'Abraham-h'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initializeBoard() {
    List<CardMemory> column = [];
    int i = 0;
    List<CardMemory> cards = widget.game.getCards();
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
              height: MediaQuery.of(context).size.height*(2/3)/howMuchCardsInColumn,
                      width: MediaQuery.of(context).size.width/columns.length,
                      child: card,
                    ))
                .toList()))
        .toList();

    return Row(children: colsWidget);
  }
}
