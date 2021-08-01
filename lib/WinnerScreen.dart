import 'package:engli_app/GetInRoom.dart';
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
              SizedBox(height: 30,),
              ElevatedButton(
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
                        fontSize: 30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void backClicked() {
    print("need to go back");
    Navigator.push(context, MaterialPageRoute(builder: (context) => GetInRoom()));
  }

  String winnerName() {
    List<Player> winners = [];
    int maxScore = 0;
    Player winner = widget.game.players[0];
    for (Player player in widget.game.players) {
      if(player.score > winner.score) {
        winner = player;
        maxScore = winner.score;
      }
    }
    for (Player player in widget.game.players) {
      if (player.score == maxScore) {
          winners.add(player);
      }
    }
    if(winners.length > 1) {
      String s = winners[0].name;
      for (Player player in winners) {
        if (player == winners[0]) {
          continue;
        }
        s +=  ", " +player.name;
      }
      return '!שיוויון' + "\n" + s;
    }
    else {
      return ' המנצח הוא  ${winner.name}';
    }
  }
}
