import 'dart:async';
import 'dart:math';
import 'package:engli_app/WinnerScreen.dart';
import 'package:engli_app/players/player.dart';
import 'package:flutter/material.dart';
import 'cards/CardMemory.dart';
import 'cards/Subject.dart';
import 'games/MemoryGame.dart';

const int maxCards = 36;

// ignore: must_be_immutable
class MemoryRoom extends StatefulWidget {
  // ignore: close_sinks
  final _streamControllerMyScore = StreamController<int>.broadcast();
  // ignore: close_sinks
  final _streamControllerEnemyScore = StreamController<int>.broadcast();
  // ignore: close_sinks
  final _streamControllerMoreTurn = StreamController<String>.broadcast();
  // ignore: close_sinks
  final _streamControllerTurn = StreamController<String>.broadcast();
  final bool computerEnemy;
  final String enemyName;

  MemoryGame game;

  MemoryRoom(bool computerEnemy, String enemyName, List<Subject> subjects)
      : this.computerEnemy = computerEnemy,
        this.enemyName = enemyName {
    this.game = new MemoryGame(
        computerEnemy,
        enemyName,
        subjects,
        this._streamControllerMyScore,
        this._streamControllerEnemyScore,
        this._streamControllerMoreTurn,
        this._streamControllerTurn);
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
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WinnerScreen(this.widget.game, null)),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_listener);
    this.howMuchCardsInColumn = sqrt(widget.game.getCards().length).round();
    initializeBoard();
  }

  @override
  void dispose() {
    widget.game.removeListener(_listener);
    this.widget._streamControllerMyScore.close();
    this.widget._streamControllerEnemyScore.close();
    this.widget._streamControllerMoreTurn.close();
    this.widget._streamControllerTurn.close();

    super.dispose();
  }

  Widget getDesign(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height / 30;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('משחק זיכרון'),
          centerTitle: true,
          shadowColor: Colors.black87,
        ),
        body: Stack(children: [
          Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: enemyNameWidget(fontSize),
                    ),
                  ),
                  Center(
                    child: enemyScoreWidget(fontSize),
                  ),
                  Expanded(child: SingleChildScrollView(child: drawBoard())),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Text(
                        ' ${widget.game.getMe().name}',
                        style: TextStyle(
                            color: Colors.lightGreen,
                            fontSize: fontSize,
                            fontFamily: 'Courgette-e'),
                      ),
                    ),
                  ),
                  Center(
                    child: myScoreWidget(fontSize),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: turnWidget(fontSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: moreTurnWidget(),
          )
        ]));
  }

  Widget myScoreWidget(double fontSize) {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerMyScore.stream,
        builder: (context, snapshot) {
          return Text(
            ' נקודות: ${widget.game.getMe().score}',
            style: TextStyle(
                color: Colors.lightGreen,
                fontSize: fontSize,
                fontFamily: 'Abraham-h'),
          );
        });
  }

  Widget enemyScoreWidget(double fontSize) {
    int rotated = 0;
    if (!this.widget.computerEnemy) {
      rotated = 2;
    }
    return StreamBuilder<int>(
        stream: this.widget._streamControllerEnemyScore.stream,
        builder: (context, snapshot) {
          return RotatedBox(
              quarterTurns: rotated,
              child: Text(
                ' נקודות: ${widget.game.getEnemy().score}',
                style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: fontSize,
                    fontFamily: 'Abraham-h'),
              ));
        });
  }

  Widget enemyNameWidget(double fontSize) {
    int rotated = 0;
    if (!this.widget.computerEnemy) {
      rotated = 2;
    }
    return RotatedBox(
      quarterTurns: rotated,
      child: Text(
        ' ${widget.game.getEnemy().name}',
        style: TextStyle(
            color: Colors.lightGreen, fontSize: fontSize, fontFamily: 'Courgette-e'),
      ),
    );
  }

  Widget moreTurnWidget() {
    return StreamBuilder<String>(
        stream: this.widget._streamControllerMoreTurn.stream,
        builder: (context, snapshot) {
          String string = snapshot.data ?? "";
          if (!this.widget.computerEnemy &&
              !(this.widget.game.getPlayerNeedTurn() is Me)) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: textMoreTurn(string),
                  ),
                ]);
          } else {
            return textMoreTurn(string);
          }
        });
  }

  Widget textMoreTurn(String string) {
    return Text(string,
        style:
            TextStyle(color: Colors.pink, fontSize: 40, fontFamily: 'Gan-h'));
  }

  Widget turnWidget(double fontSize) {
    return StreamBuilder<String>(
        stream: this.widget._streamControllerTurn.stream,
        builder: (context, snapshot) {
          return Text(
            "${widget.game.players[widget.game.turn].name}'s turn",
            style: TextStyle(
                color: Colors.pink,
                fontSize: fontSize,
                fontFamily: 'PottaOne-e'),
          );
        });
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
                      height: MediaQuery.of(context).size.height *
                          (2 / 3) /
                          howMuchCardsInColumn,
                      width: MediaQuery.of(context).size.width / columns.length,
                      child: card,
                    ))
                .toList()))
        .toList();

    return Row(children: colsWidget);
  }
}
