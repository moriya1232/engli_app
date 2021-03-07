import 'package:engli_app/QuartetsGame/QuartetsGame.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:flutter/material.dart';
import 'players/player.dart';


// TODO: diffrenet size of screen

class QuartetsRoom extends StatefulWidget {
  int chosenCard = -1;

  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {
  List<Player> players = [];

  @override
  Widget build(BuildContext context) {
    //TODO: for 3 or 2 players.
    QuartetsGame game = new QuartetsGame();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('משחק רביעיות'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Center(
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: game.getFirstPlayer().cards),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: Row(
                    children: game.getSecondPlayer().cards,
                  ),
                ),
                CardQuartets("english", "hebrew", null, "subject", "word1",
                    "word2", "word3", false),
                RotatedBox(
                  quarterTurns: 3,
                  child: Row(
                    children: game.getThirdPlayer().cards,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(),
            ),
            Container(
              height: 230,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: game.getMyPlayer().cards,
              ),
            ),
            Container(
              height: 60,
              color: Colors.black12,
              child: Row(),
            ), // TODO: for chat? microphone?
          ]),
        ),
      ),
    );
  }
}
