
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:flutter/material.dart';
import 'QuartetsGame/Turn.dart';

// TODO: diffrenet size of screen
//TODO: ask another player

class QuartetsRoom extends StatefulWidget {
  int chosenCard = -1;
  QuartetsGame game;



  QuartetsRoom(){
    this.game = new QuartetsGame();
  }

  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {

  @override
  Widget build(BuildContext context) {
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
              child: Text('${widget.game
                  .getFirstPlayer()
                  .cards
                  .length}'),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.game.getFirstPlayer().cards.length, // number of items in your list

                  //here the implementation of itemBuilder. take a look at flutter docs to see details
                  itemBuilder: (BuildContext context, int Itemindex){
                    return widget.game.getFirstPlayer().cards[Itemindex]; // return your widget
                  }
//                  children: widget.game
//                      .getFirstPlayer()
//                      .cards
                      ),
            ),
            Center(
              child: Text(
                '${widget.game
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
                if (widget.game.players.length > 2)
                  Row(children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text('${widget.game
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                            itemCount: widget.game.getSecondPlayer().cards.length, // number of items in your list

                            //here the implementation of itemBuilder. take a look at flutter docs to see details
                            itemBuilder: (BuildContext context, int Itemindex){
                              return widget.game.getSecondPlayer().cards[Itemindex]; // return your widget
                            }
//                          children: widget.game
//                              .getSecondPlayer()
//                              .cards,
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        '${widget.game
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
                                '${widget.game.deck.cards.length}',
                                style: TextStyle(fontFamily: 'Abraham-h'),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                ' תור ${widget.game.players[widget.game.turn].name}',
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
                if (widget.game.players.length > 3)
                  Row(children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        '${widget.game
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                            itemCount: widget.game.getThirdPlayer().cards.length, // number of items in your list

                            //here the implementation of itemBuilder. take a look at flutter docs to see details
                            itemBuilder: (BuildContext context, int Itemindex){
                              return widget.game.getThirdPlayer().cards[Itemindex]; // return your widget
                            }
//                          children: widget.game
//                              .getThirdPlayer()
//                              .cards,
                        ),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text('${widget.game
                          .getThirdPlayer()
                          .cards
                          .length}'),
                    ),
                  ]),
                if (widget.game.players.length == 3)
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                  )
              ],
            ),
            Expanded(
              child: getAppropriateWidget(),
            ),
            Container(
              height: 230,
              child: ListView.builder(
                shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.game.getMyPlayer().cards.length, // number of items in your list

                  //here the implementation of itemBuilder. take a look at flutter docs to see details
                  itemBuilder: (BuildContext context, int Itemindex){
                    return widget.game.getMyPlayer().cards[Itemindex]; // return your widget
                  }
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

  Widget getAppropriateWidget(){
    if(widget.game.getPlayerNeedTurn() is Me) {
      return Turn(widget.game);
    } else {
      return new Container(
        child: getAskedText()
      );
    }
  }

  Widget getAskedText() {
    if (widget.game.cardAsked != null && widget.game.nameAsked != null && widget.game.subjectAsked != null) {
      return Text(
        '${widget.game.getPlayerNeedTurn().name} asked ${widget.game.nameAsked} about the card: "${widget.game.cardAsked}" in subject: "${widget.game.subjectAsked}"',
      );
    } else if (widget.game.cardAsked == null && widget.game.nameAsked != null && widget.game.subjectAsked != null) {
      return Text(
        '${widget.game.getPlayerNeedTurn().name} asked ${widget.game.nameAsked} about subject: "${widget.game.subjectAsked}", and he does not have this subject',
      );
    } else {
      return new Container();
    }
  }

  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_listener);
    for (Player player in widget.game.players) {
      player.addListener(_listener);
    }
  }

  @override
  void dispose() {
    widget.game.removeListener(_listener);
    super.dispose();
  }
}
