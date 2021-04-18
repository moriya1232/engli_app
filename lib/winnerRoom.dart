import 'package:engli_app/players/player.dart';
import 'package:flutter/material.dart';

import 'games/Game.dart';

class WinnerRoom extends StatefulWidget {
  Game game;

  WinnerRoom(Game g) {
    this.game = g;
  }

  @override
  _winnerRoomState createState() => _winnerRoomState();
}

class _winnerRoomState extends State<WinnerRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Container(
          child: Text(
            winnerName(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.pink, fontSize: 60, fontFamily: 'Gan-h'),
          ),
        ),
      ),
    );
  }

  String winnerName() {
    //todo: if there some winners. (example: 2 players with best score from 4)
    Player winner = widget.game.players[0];
    for (Player player in widget.game.players) {
      if(player.score > winner.score) {
        winner = player;
      }
    }
    for (Player player in widget.game.players) {
      if (player.score == winner.score && player != winner) {
        winner = null;
        break;
      }
    }
    if(winner == null) {
      return '!שיוויון';
    }
    else {
      return ' המנצח הוא  ${winner.name}';
    }
  }
}
