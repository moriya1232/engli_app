import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/winnerRoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'QuartetsGame/Turn.dart';
import 'cards/Position.dart';

double heightCloseCards = 0;

class QuartetsRoom extends StatefulWidget {
  QuartetsGame game;

  QuartetsRoom() {
    this.game = new QuartetsGame();
  }

  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {
  double fontSizeNames;
  double rowHeight;
  double otherPlayersHeight;

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_listener);
    for (Player player in widget.game.players) {
      player.addListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    rowHeight = MediaQuery.of(context).size.height / 4;
    fontSizeNames = MediaQuery.of(context).size.height / 30;
    otherPlayersHeight = MediaQuery.of(context).size.height * (4 / 10);

//    bool isFirstPlayerCardAnimation = true;
//    bool isSecondPlayerCardAnimation = true;
//    bool isThirdPlayerCardAnimation = true;
//    bool isMeCardAnimation = true;
//    bool isDeckCardAnimation = true;
    bool isFirstPlayerCardAnimation = false;
    bool isSecondPlayerCardAnimation = false;
    bool isThirdPlayerCardAnimation = false;
    bool isMeCardAnimation = false;
    bool isDeckCardAnimation = false;
    Position firstPlayerPos = new Position(getFirstPlayerLeft(), getFirstPlayerTop(), null, null);
    Position secondPlayerPos = new Position(getSecondPlayerLeft(), getSecondPlayerTop(), null, null);
    Position thirdPlayerPos = new Position(null, getThirdPlayerTop(), getThirdPlayerRight(), null);
    Position mePos = new Position(getMeLeft(), null, null, getMeBottom());
    Position deckPos = new Position(getDeckLeft(), getDeckTop(), null, null);



    // if my turn and i have no cards, I need to take card from the deck and my turn pass over.
    if (widget.game.getPlayerNeedTurn() is Me &&
        this.widget.game.getPlayerNeedTurn().cards.length == 0) {
      this
          .widget
          .game
          .deck
          .giveCardToPlayer(this.widget.game.getPlayerNeedTurn());
      this.widget.game.doneTurn();
      this.widget.game.updateObservers();
    }

    // get view for asking other players.
    if (!this.widget.game.checkIfGameDone()) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('משחק רביעיות'),
          centerTitle: true,
          shadowColor: Colors.black87,
        ),
        body: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              height: otherPlayersHeight,
              child: SingleChildScrollView(
                child: Column(children: [
                  Text('${widget.game.getFirstPlayer().cards.length}'),
                  Container(
                    alignment: Alignment.center,
                    height: heightCloseCards,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.game.getFirstPlayer().cards.length,
                        // number of items in your list
                        //here the implementation of itemBuilder. take a look at flutter docs to see details
                        itemBuilder: (BuildContext context, int Itemindex) {
                          return widget.game.getFirstPlayer().cards[Itemindex];
                        }),
                  ),
                  Text(
                    '${widget.game.getFirstPlayer().name}: ${widget.game.getFirstPlayer().score}',
                    style: TextStyle(
                      fontFamily: 'Comix-h',
                      fontSize: fontSizeNames,
                    ),
                  ),
                  Container(
                    height: rowHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.game.players.length > 2)
                          Row(children: [
                            RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                  '${widget.game.getSecondPlayer().cards.length}'),
                            ),
                            RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                alignment: Alignment.center,
                                height: heightCloseCards,
//                        width: 270,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.game
                                        .getSecondPlayer()
                                        .cards
                                        .length,
                                    // number of items in your list

                                    //here the implementation of itemBuilder. take a look at flutter docs to see details
                                    itemBuilder:
                                        (BuildContext context, int Itemindex) {
                                      return widget.game
                                              .getSecondPlayer()
                                              .cards[
                                          Itemindex]; // return your widget
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
                                '${widget.game.getSecondPlayer().name}: ${widget.game.getSecondPlayer().score}',
                                style: TextStyle(
                                  fontFamily: 'Comix-h',
                                  fontSize: fontSizeNames,
                                ),
                              ),
                            ),
                          ]),
                        Stack(children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 5,
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.amberAccent,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'נותרו בערימה',
                                        style:
                                            TextStyle(fontFamily: 'Abraham-h'),
                                      ),
                                      Text(
                                        '${widget.game.deck.cards.length}',
                                        style:
                                            TextStyle(fontFamily: 'Abraham-h'),
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
                                '${widget.game.getThirdPlayer().name}: ${widget.game.getThirdPlayer().score}',
                                style: TextStyle(
                                  fontFamily: 'Comix-h',
                                  fontSize: fontSizeNames,
                                ),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Container(
                                alignment: Alignment.center,
                                height: heightCloseCards,
//                        width: 270,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.game
                                        .getThirdPlayer()
                                        .cards
                                        .length,
                                    // number of items in your list

                                    //here the implementation of itemBuilder. take a look at flutter docs to see details
                                    itemBuilder:
                                        (BuildContext context, int Itemindex) {
                                      return widget.game.getThirdPlayer().cards[
                                          Itemindex]; // return your widget
                                    }
//                          children: widget.game
//                              .getThirdPlayer()
//                              .cards,
                                    ),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                  '${widget.game.getThirdPlayer().cards.length}'),
                            ),
                          ]),
                        if (widget.game.players.length == 3)
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                          )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: getAppropriateWidget(),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.game.getMyPlayer().cards.length,
                  // number of items in your list

                  //here the implementation of itemBuilder. take a look at flutter docs to see details
                  itemBuilder: (BuildContext context, int Itemindex) {
                    return widget.game
                        .getMyPlayer()
                        .cards[Itemindex]; // return your widget
                  }),
            ),
            Container(
              color: Colors.black12,
              height: MediaQuery.of(context).size.height / 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      '${widget.game.getMyPlayer().name}: ${widget.game.getMyPlayer().score}',
                      style: TextStyle(
                        fontFamily: 'Comix-h',
                        fontSize: fontSizeNames,
                      ),
                    ),
                  ),
//                  Expanded(
//                    child:
                  Container(
                    width: 100,
                    child: RawMaterialButton(
                      padding: EdgeInsets.all(10.0),
                      onPressed: () {
                        //TODO: microphone!
                      },
                      hoverColor: Colors.black87,
                      highlightColor: Colors.lightGreen,
                      shape: CircleBorder(),
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.mic,
                        size: 35,
                      ),
                    ),
                  ),
//                  ),
                ],
              ),
            ),
          ]),
          isFirstPlayerCardAnimation
              ? _buildAnimatedPos(
                  CardQuartets("", "", null, "", "", "", "", false),
                  firstPlayerPos,
                  recalculate)
              : SizedBox(),
          isSecondPlayerCardAnimation
              ? _buildAnimatedPos(
                  CardQuartets("", "", null, "", "", "", "", false),
                  secondPlayerPos,
                  recalculate)
              : SizedBox(),
          isThirdPlayerCardAnimation
              ? _buildAnimatedPos(
                  CardQuartets("", "", null, "", "", "", "", false),
                  thirdPlayerPos,
                  recalculate)
              : SizedBox(),
          isMeCardAnimation
              ? _buildAnimatedPos(
                  CardQuartets("", "", null, "", "", "", "", false),
                  mePos,
                  recalculate)
              : SizedBox(),
          isDeckCardAnimation
              ? _buildAnimatedPos(
                  CardQuartets("", "", null, "", "", "", "", false),
                  deckPos,
                  recalculate)
              : SizedBox(),
        ]),
      );
    } else {
      // if game done - go to Winner room.
      return WinnerRoom(this.widget.game);
    }
  }

  double getFirstPlayerLeft() {
    return MediaQuery.of(context).size.width / 2 - widthCloseCard / 2;
  }

  double getFirstPlayerTop() {
    return heightCloseCards / 2;
  }

  double getSecondPlayerLeft() {
    return heightCloseCard / 2;
  }

  double getSecondPlayerTop() {
    return heightCloseCards + fontSizeNames + rowHeight / 2;
  }

  double getThirdPlayerRight() {
    return heightCloseCard / 2;
  }

  double getThirdPlayerTop() {
    return heightCloseCards + fontSizeNames + rowHeight / 2;
  }

  double getMeLeft() {
    return MediaQuery.of(context).size.width / 2 - widthCloseCard / 2;
  }

  double getMeBottom() {
    return heightCloseCards / 2;
  }

  double getDeckLeft() {
    return MediaQuery.of(context).size.width / 2 - widthCloseCard / 2;
  }

  double getDeckTop() {
    return otherPlayersHeight - rowHeight / 2;
  }

  void recalculate() {}

  Widget getAppropriateWidget() {
    if (widget.game.getPlayerNeedTurn() is Me) {
      return Turn(widget.game);
    } else {
      return new Container(alignment: Alignment.center, child: getAskedText());
    }
  }

  Widget getAskedText() {
    String asked = widget.game.getPlayerNeedTurn().name;
    String wasAsked = widget.game.nameAsked;
    String subjectAsked = widget.game.subjectAsked;
    String cardAsked = widget.game.cardAsked;
    if (cardAsked != null && wasAsked != null && subjectAsked != null) {
      return RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          style: new TextStyle(
              wordSpacing: 10,
              fontSize: 20,
              fontFamily: 'Carter-e',
              color: Colors.black87),
          children: [
            new TextSpan(
                text: '$asked',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'asked '),
            new TextSpan(
                text: '$wasAsked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'about the card: '),
            new TextSpan(
                text: '$cardAsked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'in subject: '),
            new TextSpan(
                text: '$subjectAsked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
          ],
        ),
      );
    } else if (cardAsked == null && wasAsked != null && subjectAsked != null) {
      return RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          style: new TextStyle(
              wordSpacing: 10,
              fontSize: 20,
              fontFamily: 'Carter-e',
              color: Colors.black87),
          children: [
            new TextSpan(
                text: '$asked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'asked '),
            new TextSpan(
                text: '$wasAsked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'about subject: '),
            new TextSpan(
                text: '$subjectAsked',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: ', and he does not have this subject'),
          ],
        ),
      );
    } else {
      return new Container();
    }
  }

  void _listener() {
    setState(() {});
  }

  Widget _buildAnimatedPos(Widget card, Position position, Function onEnd) {
    return AnimatedPositioned(
      onEnd: onEnd,
      left: position.getLeft(),
      right: position.getRight(),
      top: position.getTop(),
      bottom: position.getBottom(),
      child: card,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    widget.game.removeListener(_listener);
    for (Player player in widget.game.players) {
      player.removeListener(_listener);
    }
    super.dispose();
  }
}
