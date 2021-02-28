import 'dart:math';
import 'package:flutter/material.dart';
import 'cards/CardMemory.dart';
import 'players/player.dart';

const int maxCards = 36;

class MemoryRoom extends StatefulWidget {
  @override
  _MemoryRoomState createState() => _MemoryRoomState();
}

class _MemoryRoomState extends State<MemoryRoom> {
  List<Player> players = [];

  @override
  Widget build(BuildContext context) {
    Me me = createPlayer(true);
    Other enemy = createPlayer(false);
    players.add(me);
    players.add(enemy);
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
                  child: Text(':נקודות'),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  createBoard(),
                ],
              ),
              Center(
                child: Container(
                  height: 70,
                  child: Text(':נקודות'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget createBoard() {
    List<CardMemory> cards = createCards();
    List<List<CardMemory>> columns = [];
    List<CardMemory> column = [];
    int howMuchCardsInColumn = sqrt(cards.length).round();
    int i = 0;
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

  Player createPlayer(bool isMe) {
    List<CardMemory> cards = [];
    if (isMe) {
      return Me(cards);
    } else {
      return Other(cards);
    }
  }

  List<CardMemory> createCards() {
    // TODO: insert here the cards that we get from the user.
    List<CardMemory> cards = [];

    for (int i = 0; i < 36; i++) {
      if (i % 2 == 0) {
        cards.add(CardMemory("english", "hebrew", true));
      } else {
        cards.add(CardMemory("english", "hebrew", false));
      }
    }
    return cards;
  }
}
