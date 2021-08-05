import 'package:engli_app/players/player.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/material.dart';
import 'ChooseGame.dart';
import 'games/Game.dart';

class WinnerScreen extends StatefulWidget {
  final Game game;
  final String gameId;

  WinnerScreen(Game g, String gameId)
      : this.game = g,
        this.gameId = gameId;

  @override
  _WinnerRoomState createState() => _WinnerRoomState();
}

class _WinnerRoomState extends State<WinnerScreen> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Player> winners = getWinners();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
      ),
      body: Stack(
        children: [
          Center(child: Image(image: AssetImage("images/fireworks.gif"))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                if (winners.length == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "The Winner:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87, fontSize: 30, fontFamily: 'Carter-e'),
                      ),
                      Container(
                        width: width,
                        height: height/2,
                        child: FittedBox(
                          child: Text(
                            getWinnersString(winners),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.pink, fontFamily: 'Carter-e'),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (winners.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "The Winners:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87, fontSize: 30, fontFamily: 'Carter-e'),
                    ),
                    Container(
                      width: width,
                      height: height/2,
                      child: FittedBox(
                        child: Text(
                          getWinnersString(winners),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.pink, fontFamily: 'Carter-e'),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 30,
              ),
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
        ],
      ),
    );
  }

  void backClicked() {
    if (this.widget.gameId != null) {
      GameDatabaseService().deleteGame(this.widget.gameId);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChooseGame()));
  }

  List<Player> getWinners() {
    List<Player> winners = [];
    int maxScore = 0;
    for (Player player in widget.game.players) {
      if (player.score > maxScore) {
//        winner = player;
        maxScore = player.score;
      }
    }
    for (Player player in widget.game.players) {
      if (player.score == maxScore) {
        winners.add(player);
      }
    }
    return winners;
  }

  String getWinnersString(List<Player> winners) {
    if(winners.length <= 0) {return "";}
    Player winner = winners[0];
    if (winners.length > 1) {
      String s = winners[0].name;
      for (Player player in winners) {
        if (player == winners[0]) {
          continue;
        }
        s += ",\n" + player.name;
      }
      return s;
    } else {
      return winner.name;
    }
  }
}
