import 'package:engli_app/QuartetsGame/Constants.dart';
import 'package:engli_app/QuartetsGame/QuartetsGame.dart';
import 'package:flutter/material.dart';
import 'players/player.dart';

// TODO: diffrenet size of screen
//TODO: ask another player 

class QuartetsRoom extends StatefulWidget {
  int chosenCard = -1;

  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {
  List<Player> players = [];

  @override
  Widget build(BuildContext context) {
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
      Container(
        alignment: Alignment.center,
        height: 100,
          child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
                children: game.getFirstPlayer().cards),
      ),
                Center(child: Text('${game.getFirstPlayer().name}',
                    style: TextStyle(
                      fontFamily: 'Comix-h',
                      fontSize: 20,
                    ),
                ),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (howMuchPlayers > 2)
                Row(
                      children: [RotatedBox(quarterTurns: 1,
                    child: Text('${game
                        .getSecondPlayer()
                        .cards
                        .length}'),),
                //if (howMuchPlayers > 2)
                  RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 270,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: game
                            .getSecondPlayer()
                            .cards,
                      ),
                    ),
                  ),
                //if (howMuchPlayers > 2)
                  RotatedBox(
                    quarterTurns: 1,
                    child: Text('${game
                        .getSecondPlayer()
                        .name
                    }',
                      style: TextStyle(
                        fontFamily: 'Comix-h',
                        fontSize: 20,
                      ),),
                  ),]),

                Stack(children: [
                  Padding( 
                    padding: EdgeInsets.all(20),
                    child:Container(
                    height: 150,
                    width: 100,
                    color: Colors.amberAccent,
                    
                  ),),
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
                if (howMuchPlayers > 3)
                  Row(
                    children: [
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
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 270,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                    children: game.getThirdPlayer().cards,
                    ),
                  ),
                ),
                  RotatedBox(
                  quarterTurns: 3,
                  child: Text('${game.getThirdPlayer().cards.length}'),
                ),
                    ]),
                if (howMuchPlayers==3)
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                  )

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
