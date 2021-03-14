
import 'package:engli_app/QuartetsGame/QuartetsGame.dart';
import 'package:flutter/material.dart';
import 'QuartetsGame/Turn.dart';

// TODO: diffrenet size of screen
//TODO: ask another player

class QuartetsRoom extends StatefulWidget {
  int chosenCard = -1;
//  Player playerChosenToAsk;
//  String subjectToAsk;

  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {


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
            Center(
              child: Text('${game
                  .getFirstPlayer()
                  .cards
                  .length}'),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: game
                      .getFirstPlayer()
                      .cards),
            ),
            Center(
              child: Text(
                '${game
                    .getFirstPlayer()
                    .name}',
                style: TextStyle(
                  fontFamily: 'Comix-h',
                  fontSize: 20,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (game.players.length > 2)
                  Row(children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text('${game
                          .getSecondPlayer()
                          .cards
                          .length}'),
                    ),
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
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        '${game
                            .getSecondPlayer()
                            .name}',
                        style: TextStyle(
                          fontFamily: 'Comix-h',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ]),
                Stack(children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      height: 150,
                      width: 100,
                      color: Colors.amberAccent,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                              SizedBox(
                                height: 30,
                              ),
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
                if (game.players.length > 3)
                  Row(children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        '${game
                            .getThirdPlayer()
                            .name}',
                        style: TextStyle(
                          fontFamily: 'Comix-h',
                          fontSize: 20,
                        ),
                      ),
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
                          children: game
                              .getThirdPlayer()
                              .cards,
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text('${game
                          .getThirdPlayer()
                          .cards
                          .length}'),
                    ),
                  ]),
                if (game.players.length == 3)
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                  )
              ],
            ),
            Expanded(
              child: Turn(game),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  SizedBox(
//                    width: 100,
//                    child: ListView(shrinkWrap: true, children: [
//                      for (Player player in game.players)
//                        if (player is Other)
//                          ListTile(
//                              title: Text(
//                                //card in quertet
//                                "",
//                                style: TextStyle(
//                                  fontSize: 15,
//                                  fontFamily: 'Nehama-h',
//                                ),
//                              ),
////                              leading: Radio(
////                                onChanged: (value) {
////                                  this.subjectToAsk = value;
////                                },
////                              ),
//                          ),
//                    ]),
//                  ),
//                  SizedBox(
//                    width: 100,
//                    child: ListView(shrinkWrap: true, children: [
//                      for (String subject in game.getMyPlayer().getSubjects())
//                        Card(
//                          child: Center(
//                            child: Text(
//                              //card in quertet
//                              subject,
//                              style: TextStyle(
//                                fontSize: 15,
//                                fontFamily: 'Nehama-h',
//                              ),
//                            ),
//                          ),
//                        ),
//                    ]),
//                  ),
//                  SizedBox(
//                    width: 100,
//                    child: ListView(shrinkWrap: true, children: [
//                      DropdownButton<String>(
//                        value: widget.playerChosenToAsk.name,
//                        //hint: new Text("בחר כמות משתתפים"),
//                        icon: Icon(Icons.arrow_downward),
//                        iconSize: 10,
//                        elevation: 16,
//                        style: TextStyle(color: Colors.black87),
//                        underline: Container(
//                          height: 2,
//                          width: 10,
//                          color: Colors.amberAccent,
//                        ),
//                        onChanged: (String newValue) {
//                          setState(() {
//                            widget.playerChosenToAsk = game.getPlayerByName(newValue);
//                          });
//                        },
//                        items: names.map<DropdownMenuItem<String>>((String value) {
//                          return DropdownMenuItem<String>(
//                            value: value,
//                            child: Text(
//                              value,
//                              style: TextStyle(fontSize: 25),
//                            ),
//                          );
//                        }).toList(),
//                      ),
//                    ]),
//                  ),
//                ],
//              ),
            ),
            Container(
              height: 230,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: game
                    .getMyPlayer()
                    .cards,
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
