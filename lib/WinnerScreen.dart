import 'package:engli_app/players/player.dart';
import 'package:flutter/material.dart';
import 'games/Game.dart';

class WinnerScreen extends StatefulWidget {
  Game game;

  WinnerScreen(Game g) {
    this.game = g;
  }

  @override
  _winnerRoomState createState() => _winnerRoomState();
}

class _winnerRoomState extends State<WinnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Text(
                  winnerName(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.pink, fontSize: 60, fontFamily: 'Gan-h'),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                  height: 140,
                  width: 330,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      primary: Colors.amberAccent,
                    ),
                    onPressed: () {
                      backClicked();
                    },
                    child: Text('חזור למשחק',
                        style: TextStyle(
                            fontFamily: 'Comix-h',
                            color: Colors.black87,
                            fontSize: 50)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
  void backClicked() {
    Navigator.pop(context);
    Navigator.pop(context);
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
