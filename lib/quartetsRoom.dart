import 'package:engli_app/QuartetsGame/QuartetsGame.dart';
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Center(child: Text('${game.getFirstPlayer().cards.length}'),),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: game.getFirstPlayer().cards),
                Center(child: Text('${game.getFirstPlayer().name}',
                    style: TextStyle(
                      fontFamily: 'Comix-h',
                      fontSize: 20,
                    ),
                ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(quarterTurns: 1,
                  child :Text('${game.getSecondPlayer().cards.length}'),),
                RotatedBox(
                  quarterTurns: 1,
                  child: Row(
                    children: game.getSecondPlayer().cards,
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text('${game.getSecondPlayer().name}',
                    style: TextStyle(
                      fontFamily: 'Comix-h',
                      fontSize: 20,
                    ),),
                ),
                Stack(children: [
                  Padding( 
                    padding: EdgeInsets.all(20),
                    child:Container(
                    height: 150,
                    width: 100,
                    color: Colors.amberAccent,
                    
                  ),),
//                  CardQuartets("english", "hebrew", null, "subject", "word1",
//                      "word2", "word3", false),
                  Positioned.fill(
                    child:
                    Align(
                      child:  Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Text(
                          'נותרו בערימה',
                          style: TextStyle(fontFamily: 'Abraham-h'),
                        ),
                        Text(
                          '${game.deck.cards.length}',
                          style: TextStyle(fontFamily: 'Abraham-h'),
                        ),
                        SizedBox(height: 30,),
                            Text(
                              ' תור ${game.players[game.turn].name}',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontFamily: 'Abraham-h'),
                            ),

                          ]),
                      ),
                    ),
                  )
                ]),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text('${game.getThirdPlayer().name}',
                    style: TextStyle(
                      fontFamily: 'Comix-h',
                      fontSize: 20,
                    ),),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Row(
                    children: game.getThirdPlayer().cards,
                  ),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text('${game.getThirdPlayer().cards.length}'),
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
              height: 50,
              color: Colors.black12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mic,
                    size: 35,
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
