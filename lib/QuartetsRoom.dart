//TODO:
// arrange code
// double click.

// TODO: check::
// limit for 4 players. -- check!!!

import 'dart:async';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'QuartetsGame/Turn.dart';
import 'WinnerScreen.dart';
import 'cards/CardQuartets.dart';
import 'cards/Position.dart';
import 'Constants.dart';

// ignore: must_be_immutable
class QuartetsRoom extends StatefulWidget {
  QuartetsGame game;
  // ignore: close_sinks
  final _scGameStart = StreamController<bool>.broadcast();
  // ignore: close_sinks
  final _streamControllerFirst = StreamController<Position>.broadcast();
  // ignore: close_sinks
  final _streamControllerSecond = StreamController<Position>.broadcast();
  // ignore: close_sinks
  final _streamControllerThird = StreamController<Position>.broadcast();
  // ignore: close_sinks
  final _streamControllerMe = StreamController<Position>.broadcast();
  // ignore: close_sinks
  final _streamControllerDeck = StreamController<Position>.broadcast();

  // ignore: close_sinks
  final _streamControllerTurn = StreamController<int>.broadcast();
  // final _streamControllerStringsTurn = StreamController<int>.broadcast();

  // ignore: close_sinks
  final _streamControllerMyCards = StreamController<int>.broadcast();
  // ignore: close_sinks
  final _streamControllerOtherPlayersCards = StreamController<int>.broadcast();
  // ignore: close_sinks
  final _streamControllerStringsInDeck = StreamController<int>.broadcast();
  // ignore: close_sinks
  final _streamControllerMyScore = StreamController<int>.broadcast();
  // ignore: close_sinks
  final _getQuartet = StreamController<String>.broadcast();
  // ignore: close_sinks
  final _isFinish = StreamController<bool>.broadcast();
  String stringToSpeak = "";

  QuartetsRoom(
    String gameId,
    bool isManager,
    bool againstComputer,
  ) {
    this.game = new QuartetsGame(
        gameId,
        isManager,
        this._scGameStart,
        this._streamControllerFirst,
        this._streamControllerSecond,
        this._streamControllerThird,
        this._streamControllerMe,
        this._streamControllerDeck,
        this._streamControllerTurn,
        this._streamControllerMyCards,
        this._streamControllerMyScore,
        this._streamControllerOtherPlayersCards,
        this._streamControllerStringsInDeck,
        this._getQuartet,
        this._isFinish);
    if (againstComputer) {
      game.againstComputer = againstComputer;
    }
    this.game.createGame();
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
    this.firstCard = getAnimationCard();
    this.secondCard = getAnimationCard();
    this.thirdCard = getAnimationCard();
    this.meCard = getAnimationCard();
    this.deckCard = getAnimationCard();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setConstants();
    firstBuild = false;
    return _isFinishScreen();
  }

  Widget _isFinishScreen() {
    return StreamBuilder<bool>(
        stream: this.widget._isFinish.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return WinnerScreen(this.widget.game, this.widget.game.gameId);
          } else {
            return getUpdatedView();
          }
        });
  }

  Widget getView() {
    return Scaffold(
      body: Stack(children: [
        isGameFinish(),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            height: otherPlayersHeight,
            child: SingleChildScrollView(
              child: Column(children: [
                if (widget.game.players.length > 1) getFirstPlayerView(),
                Container(
                  height: rowHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.game.players.length > 2)
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: getSecondPlayerView(),
                          ),
                        ),
                      Expanded(
                        child: Stack(children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 5,
                                width: MediaQuery.of(context).size.width / 4,
                                color: Colors.amberAccent,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: getStringsOnDeck(),
                            ),
                          )
                        ]),
                      ),
                      if (widget.game.players.length > 3)
                        Expanded(
                            child: RotatedBox(
                          quarterTurns: 3,
                          child: getThirdPlayerView(),
                        )),
                      if (widget.game.players.length == 3)
                        Expanded(child: Container()),
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
                  child: getMyText(),
                ),
                Container(
                  width: 100,
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(10.0),
                    onPressed: () {
                      this.widget.game.speak(this.widget.stringToSpeak);
                    },
                    hoverColor: Colors.black87,
                    highlightColor: Colors.lightGreen,
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.hearing,
                      size: 35,
                    ),
                  ),
                ),
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
        Center(child: getQuartetWidget()),
      ]),
    );
  }

  Widget getQuartetWidget() {
    return StreamBuilder<String>(
        stream: this.widget._getQuartet.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return new Container();
          }
          return getQuartetText(snapshot.data);
        });
  }

  Widget getQuartetText(String string) {
    return Text(string + " achieved quartet!",
        textAlign: TextAlign.center,
        style: TextStyle(
            backgroundColor: Colors.white,
            decorationStyle: TextDecorationStyle.double,
            color: Colors.pink,
            fontSize: 40,
            fontFamily: 'Courgette-e'));
  }

  Widget getUpdatedView() {
    return StreamBuilder<bool>(
        stream: widget._scGameStart.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return getView();
          } else {
            return Container();
          }
        });
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
        initialData: 0,
        builder: (context, snapshot) {
          if (this.widget.game.isFinished) {
            return Container();
          } else if (widget.game.getPlayerNeedTurn() is Me && !this.widget.game.isFinished) {
            Turn t = Turn(widget.game);
            return t;
          } else {
            return new Container(
                alignment: Alignment.center, child: getAskedText());
          }
        });
  }

  Widget getAskedText() {
    String asked = widget.game.playerTakeName;
    String wasAsked = widget.game.playerTokenName;
    String subjectAsked = widget.game.subjectAsked;
    String cardAsked = widget.game.cardAsked;
    bool succ = widget.game.successTakeCard;
    if (succ == null) {
      return new Container();
    }
    //take from the deck
    if (asked != null && wasAsked == "deck") {
      this.widget.stringToSpeak = asked + " drew a card from the deck";
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
            new TextSpan(text: 'drew a card from the deck'),
          ],
        ),
      );
    }
    // ask about spec card
    else if (succ &&
        cardAsked != null &&
        wasAsked != null &&
        subjectAsked != null) {
      this.widget.stringToSpeak = asked +
          " took a " +
          cardAsked +
          " card from " +
          wasAsked +
          "subject: " +
          subjectAsked;
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
            new TextSpan(text: 'took a '),
            new TextSpan(
                text: '$cardAsked ',
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'card from '),
            new TextSpan(
                text: '$wasAsked\n',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'Subject: '),
            new TextSpan(
                text: '$subjectAsked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
          ],
        ),
      );
    }
    // ask about subject and doesnt have this subject
    else if (!succ &&
        cardAsked == null &&
        wasAsked != null &&
        subjectAsked != null) {
      this.widget.stringToSpeak = asked +
          " asked " +
          wasAsked +
          " about the subject " +
          subjectAsked +
          ", but " +
          wasAsked +
          " didn't have that subject";
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
            new TextSpan(text: 'about the subject '),
            new TextSpan(
                text: '$subjectAsked',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: ', but '),
            new TextSpan(
                text: '$wasAsked',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: " didn't have that subject"),
          ],
        ),
      );
    }
    // ask about subject and he doesn't have the card.
    else if (!succ &&
        cardAsked != null &&
        wasAsked != null &&
        subjectAsked != null) {
      this.widget.stringToSpeak = asked +
          " asked " +
          wasAsked +
          " for a " +
          cardAsked +
          ", but " +
          wasAsked +
          "didn't have the card. subject " +
          subjectAsked;
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
            new TextSpan(text: 'for a '),
            new TextSpan(
                text: '$cardAsked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: 'but '),
            new TextSpan(
                text: '$wasAsked ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            new TextSpan(text: "didn't have the card.\nsubject: "),
            new TextSpan(
                text: '$subjectAsked',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
          ],
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget _buildAnimatedPos(
      Widget card, Position position, StreamController sc) {
    position.visible = false;
    return StreamBuilder<Position>(
        stream: sc.stream,
        initialData: position,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox();
          }
          return AnimatedPositioned(
            left: snapshot.data.getLeft(),
            top: snapshot.data.getTop(),
            child: snapshot.data.getVisible() ? card : SizedBox(),
            duration: Duration(seconds: 1, milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
        });
  }



  Widget getFirstPlayerView() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerOtherPlayersCards.stream,
        builder: (context, snapshot) {
          return Column(children: [
            Text('${widget.game.getFirstPlayer().cards.length}'),
            Container(
              alignment: Alignment.center,
              height: heightCloseCard,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.game.getFirstPlayer().cards.length,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return widget.game.getFirstPlayer().cards[itemIndex];
                  }),
            ),
            Text(
              '${widget.game.getFirstPlayer().name}: ${widget.game.getFirstPlayer().score}',
              style: TextStyle(
                fontFamily: 'Courgette-e',
                fontSize: fontSizeNames,
              ),
            ),
          ]);
        });
  }

  Widget getSecondPlayerView() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerOtherPlayersCards.stream,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(children: [
              Text(
                '${widget.game.getSecondPlayer().name}: ${widget.game.getSecondPlayer().score}',
                style: TextStyle(
                  fontFamily: 'Courgette-e',
                  fontSize: fontSizeNames,
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: heightCloseCard,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.game.getSecondPlayer().cards.length,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return widget.game
                          .getSecondPlayer()
                          .cards[itemIndex]; // return your widget
                    }),
              ),
              Text('${widget.game.getSecondPlayer().cards.length}'),
            ]),
          );
        });
  }

  Widget getThirdPlayerView() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerOtherPlayersCards.stream,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(children: [
              Text(
                '${widget.game.getThirdPlayer().name}: ${widget.game.getThirdPlayer().score}',
                style: TextStyle(
                  fontFamily: 'Courgette-e',
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
                    itemCount: widget.game.getThirdPlayer().cards.length,
                    itemBuilder: (BuildContext context, int itemIndex) {
                      return widget.game
                          .getThirdPlayer()
                          .cards[itemIndex]; // return your widget
                    }),
              ),
              Text('${widget.game.getThirdPlayer().cards.length}'),
            ]),
          );
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
              itemBuilder: (BuildContext context, int itemIndex) {
                return widget.game
                    .getMyPlayer()
                    .cards[itemIndex]; // return your widget
              });
        });
  }

  @override
  void dispose() {
    //dispose listens.
    this.widget.game.listenToPlayersInGame.cancel();
    this.widget.game.listenToSpecGame.cancel();
    //dispose all the controlles.
    this.widget._streamControllerFirst.close();
    this.widget._streamControllerSecond.close();
    this.widget._streamControllerThird.close();
    this.widget._streamControllerMe.close();
    this.widget._streamControllerDeck.close();
    this.widget._streamControllerTurn.close();
    this.widget._streamControllerMyCards.close();
    this.widget._streamControllerMyScore.close();
    this.widget._streamControllerOtherPlayersCards.close();
    this.widget._streamControllerStringsInDeck.close();
    this.widget._scGameStart.close();
    this.widget._isFinish.close();
    this.widget._getQuartet.close();
    print("in dispose");
    super.dispose();
  }

  Widget getStringsOnDeck() {
    return StreamBuilder<int>(
        initialData: 1,
        stream: this.widget._streamControllerStringsInDeck.stream,
        builder: (context, snapshot) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'נותרו בערימה',
                  style: TextStyle(fontFamily: 'Abraham-h'),
                ),
                Text(
                  '${widget.game.deck.getCards().length}',
                  style: TextStyle(fontFamily: 'Abraham-h'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Turn:",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: 'PottaOne-e'),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  "${widget.game.listTurn[widget.game.turn].name}",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: 'PottaOne-e'),
                ),
              ]);
        });
  }

  Widget getMyText() {
    return StreamBuilder<int>(
        stream: this.widget._streamControllerMyScore.stream,
        builder: (context, snapshot) {
          return Text(
            '${widget.game.getMyPlayer().name}: ${widget.game.getMyPlayer().score}',
            style: TextStyle(
              fontFamily: 'Courgette-e',
              fontSize: fontSizeNames,
            ),
          );
        });
  }

  Widget isGameFinish() {
    return StreamBuilder<bool>(
        stream: this.widget._isFinish.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WinnerScreen(widget.game, widget.game.gameId)),
            );
          }
          return new Container();
        });
  }

  Widget getAnimationCard() {
    CardQuartets card = CardQuartets("", "", null, "", "", "", "", false);
    return card;
  }
}
