import 'dart:async';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/Player.dart';
import 'package:engli_app/WinnerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'QuartetsGame/Turn.dart';
import 'cards/CardQuartets.dart';
import 'cards/Position.dart';
import 'Constants.dart';


class QuartetsRoom extends StatefulWidget {
  QuartetsGame game;
  final _streamControllerFirst = StreamController<Position>.broadcast();
  final _streamControllerSecond = StreamController<Position>.broadcast();
  final _streamControllerThird = StreamController<Position>.broadcast();
  final _streamControllerMe = StreamController<Position>.broadcast();
  final _streamControllerDeck = StreamController<Position>.broadcast();

  final _streamControllerTurn = StreamController<int>.broadcast();

  final _streamControllerMyCards = StreamController<int>.broadcast();
  final _streamControllerOtherPlayersCards = StreamController<int>.broadcast();
  final _streamControllerStringsInDeck = StreamController<int>.broadcast();

  QuartetsRoom() {
    this.game = new QuartetsGame(
        this._streamControllerFirst,
        this._streamControllerSecond,
        this._streamControllerThird,
        this._streamControllerMe,
        this._streamControllerDeck,
        this._streamControllerTurn,
        this._streamControllerMyCards,
        this._streamControllerOtherPlayersCards,
    this._streamControllerStringsInDeck);
  }

  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {
  CardQuartets firstCard;
  CardQuartets secondCard;
  CardQuartets thirdCard;
  CardQuartets meCard;
  CardQuartets deckCard;

  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    firstBuild = true;
    this.widget.game.addListener(_listener);
//    for (Player player in widget.game.players) {
//      player.addListener(_listener);
//    }
    this.firstCard = getAnimationCard();
    this.secondCard = getAnimationCard();
    this.thirdCard = getAnimationCard();
    this.meCard = getAnimationCard();
    this.deckCard = getAnimationCard();
  }

  @override
  Widget build(BuildContext context) {
    setConstants();
    firstBuild = false;
    // if my turn and i have no cards, I need to take card from the deck and my turn pass over.
    if (widget.game.getPlayerNeedTurn() is Me &&
        this.widget.game.getPlayerNeedTurn().cards.length == 0) {
      this
          .widget
          .game
          .deck
          .giveCardToPlayer(this.widget.game.getPlayerNeedTurn());
      this.widget.game.doneTurn();
      //this.widget.game.updateObservers();
    }

    // get view for asking other players.
//    if (!this.widget.game.checkIfGameDone()) {
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
                  getFirstPlayerView(),
                  Container(
                    height: rowHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.game.players.length > 2)
                          RotatedBox(
                            quarterTurns: 1,
                            child: getSecondPlayerView(),
                          ),
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
                                child: getStringsOnDeck(),
                              ),
                            ),
                          )
                        ]),
                        if (widget.game.players.length > 3)
                          RotatedBox(
                            quarterTurns: 3,
                            child: getThirdPlayerView(),
                          ),
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
              child: getAppropriateWidgetForTurn(),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: getMyCards(),
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
          _buildAnimatedPos(this.firstCard, this.firstCard.position,
              widget._streamControllerFirst),
          _buildAnimatedPos(this.secondCard, this.secondCard.position,
              widget._streamControllerSecond),
          _buildAnimatedPos(this.thirdCard, this.thirdCard.position,
              widget._streamControllerThird),
          _buildAnimatedPos(
              this.meCard, this.meCard.position, widget._streamControllerMe),
          _buildAnimatedPos(this.deckCard, this.deckCard.position,
              widget._streamControllerDeck),
        ]),
      );
//    } else {
      // if game done - go to Winner room.
//      return WinnerRoom(this.widget.game);
//    }
  }

  void setConstants() {
    if (firstBuild) {
      rowHeight = MediaQuery.of(context).size.height / 4;
      fontSizeNames = MediaQuery.of(context).size.height / 30;
      otherPlayersHeight = MediaQuery.of(context).size.height * (4 / 10);
      widthScreen = MediaQuery.of(context).size.width;
      heightScreen = MediaQuery.of(context).size.height;
      heightCloseCard = 80;
      widthCloseCard = 60;
      this.firstCard.position = firstPlayerPos =
          new Position(getFirstPlayerLeft(), getFirstPlayerTop(), null, null);
      this.secondCard.position = secondPlayerPos =
          new Position(getSecondPlayerLeft(), getSecondPlayerTop(), null, null);
      this.thirdCard.position = thirdPlayerPos =
          new Position(getThirdPlayerLeft(), getThirdPlayerTop(), null, null);
      this.meCard.position =
          mePos = new Position(getMeLeft(), getMeTop(), null, null);
      this.deckCard.position =
          deckPos = new Position(getDeckLeft(), getDeckTop(), null, null);
    }
  }

  Widget getAppropriateWidgetForTurn() {
    return StreamBuilder<int>(
        stream: widget._streamControllerTurn.stream,
        builder: (context, snapshot) {
          if (widget.game.getPlayerNeedTurn() is Me) {
            return Turn(widget.game, this.widget._streamControllerTurn);
          } else {
            return new Container(
                alignment: Alignment.center, child: getAskedText());
          }
        });
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
    //setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WinnerScreen(this.widget.game)),
    );
  }

  Widget _buildAnimatedPos(
      Widget card, Position position, StreamController sc) {
    return StreamBuilder<Position>(
        stream: sc.stream,
        builder: (context, snapshot) {
          ///snapshot.data?? "first" == snapshot.data != null ? snapshot.data : "first"
          if (snapshot.data == null) {
            return SizedBox();
          }
          return AnimatedPositioned(
            left: snapshot.data.getLeft(),
//            right: snapshot.data.getRight(),
            top: snapshot.data.getTop(),
//            bottom: snapshot.data.getBottom(),
            child: snapshot.data.getVisible() ? card : SizedBox(),
            duration: Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
          );
        });
  }

  Widget getFirstPlayerView() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerOtherPlayersCards.stream,
        builder: (context, snapshot) {
      return Column(children: [
        Text('${widget.game
            .getFirstPlayer()
            .cards
            .length}'),
        Container(
          alignment: Alignment.center,
          height: heightCloseCard,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.game
                  .getFirstPlayer()
                  .cards
                  .length,
              // number of items in your list

              itemBuilder: (BuildContext context, int Itemindex) {
                return widget.game
                    .getFirstPlayer()
                    .cards[Itemindex];
              }),
        ),
        Text(
          '${widget.game
              .getFirstPlayer()
              .name}: ${widget.game
              .getFirstPlayer()
              .score}',
          style: TextStyle(
            fontFamily: 'Comix-h',
            fontSize: fontSizeNames,
          ),
        ),
      ]);
    });
  }

  Widget getSecondPlayerView() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerOtherPlayersCards.stream,
        builder: (context, snapshot)
    {
      return Column(children: [
        Text(
          '${widget.game
              .getSecondPlayer()
              .name}: ${widget.game
              .getSecondPlayer()
              .score}',
          style: TextStyle(
            fontFamily: 'Comix-h',
            fontSize: fontSizeNames,
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: heightCloseCard,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.game
                  .getSecondPlayer()
                  .cards
                  .length,
              // number of items in your list
              itemBuilder: (BuildContext context, int Itemindex) {
                return widget.game
                    .getSecondPlayer()
                    .cards[Itemindex]; // return your widget
              }
          ),
        ),
        Text('${widget.game
            .getSecondPlayer()
            .cards
            .length}'),
      ]);
    });
  }

  Widget getThirdPlayerView() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerOtherPlayersCards.stream,
        builder: (context, snapshot)
    {
      return Column(children: [
        Text(
          '${widget.game
              .getThirdPlayer()
              .name}: ${widget.game
              .getThirdPlayer()
              .score}',
          style: TextStyle(
            fontFamily: 'Comix-h',
            fontSize: fontSizeNames,
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: heightCloseCard,
//                        width: 270,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.game
                  .getThirdPlayer()
                  .cards
                  .length,
              // number of items in your list
              itemBuilder: (BuildContext context, int Itemindex) {
                return widget.game
                    .getThirdPlayer()
                    .cards[Itemindex]; // return your widget
              }
          ),
        ),
        Text('${widget.game
            .getThirdPlayer()
            .cards
            .length}'),
      ]);
    });
  }

  Widget getMyCards() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerMyCards.stream,
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.game.getMyPlayer().cards.length,
              // number of items in your list

              //here the implementation of itemBuilder. take a look at flutter docs to see details
              itemBuilder: (BuildContext context, int Itemindex) {
                return widget.game
                    .getMyPlayer()
                    .cards[Itemindex]; // return your widget
              });
        });
  }

  @override
  void dispose() {
    widget.game.removeListener(_listener);
//    for (Player player in widget.game.players) {
//      player.removeListener(_listener);
//    }
  //dispose all the controlles.
    this.widget._streamControllerFirst.close();
    this.widget._streamControllerSecond.close();
    this.widget._streamControllerThird.close();
    this.widget._streamControllerMe.close();
    this.widget._streamControllerDeck.close();

    this.widget._streamControllerTurn.close();

    this.widget._streamControllerMyCards.close();
    this.widget._streamControllerOtherPlayersCards.close();
    this.widget._streamControllerStringsInDeck.close();

    super.dispose();
  }

  Widget getStringsOnDeck() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerStringsInDeck.stream,
        builder: (context, snapshot)
    {
      return Column(
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
          ]);
    });
  }

  Widget getAnimationCard() {
    CardQuartets card = CardQuartets("", "", null, "", "", "", "", false);
    return card;
  }
}