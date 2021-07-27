import 'dart:core';
import 'package:engli_app/games/MemoryGame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CardGame.dart';

class CardMemory extends CardGame {
  bool _isEnglishCard;
  bool _isClose;
  MemoryGame _game;
  bool _computerEnemy;

  CardMemory(String english, String hebrew, bool isEnglish, bool computerEnemy)
      : super(english, hebrew) {
    print(computerEnemy);
    this._isEnglishCard = isEnglish;
    this._isClose = true;
    this._game=null;
    this._computerEnemy = computerEnemy;
  }

  bool getIsClose() {
    return this._isClose;
  }

  void setIsClose(bool b) {
    this._isClose = b;
  }

  void setGame(MemoryGame mg) {
    this._game = mg;
  }

  @override
  _CardMemoryState createState() => _CardMemoryState();

  @override
  Future changeStatusCard(bool b) {
    this._isClose = b;
    return new Future.delayed(const Duration(seconds: 1));
  }
}

class _CardMemoryState extends State<CardMemory> {
  @override
  Widget build(BuildContext context) {
    if (widget._isClose) {
      return GestureDetector(
        child: getCloseCard(context),
        onTap: () async {
          if (widget._game.allowSwapCards()) {
            await changeStatusCard(false);
            widget._game.cardClicked();
          }
        },
      );
    } else {
      return getOpenCard(context);
    }
  }

  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.addListener(_listener);
  }


  Future changeStatusCard(bool isClose) async {
    setState(() {
      // check if can change to:
      // widget.changeStatusCard(isClose);
      widget._isClose = isClose;
    });
    return new Future.delayed(const Duration(seconds: 2));
  }

  Widget getOpenCard(BuildContext context) {
      return new Card(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column ( children: [
              this.widget._computerEnemy? SizedBox(): RotatedBox(
                quarterTurns: 2,
                child: textCard(),
              ),
              textCard(),
            ]),
          ),
      );

  }

  Widget textCard() {
    return Text(
      widget._isEnglishCard? widget.english: widget.hebrew,
      style: TextStyle(
          fontFamily: widget._isEnglishCard?"Carter-e":"Dorian-h"
      ),
    );
  }

  Widget getCloseCard(BuildContext context) {
    return Card(
        color: Colors.amberAccent,
    );
  }
}
