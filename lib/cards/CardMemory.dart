import 'dart:core';
import 'package:engli_app/games/MemoryGame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CardGame.dart';

class CardMemory extends CardGame {
  bool isEnglishCard;
  bool isClose;
  MemoryGame game;

  CardMemory(String english, String hebrew, bool isEnglish)
      : super(english, hebrew) {
    this.isEnglishCard = isEnglish;
    this.isClose = true;
    this.game=null;
  }

  void setGame(MemoryGame mg) {
    this.game = mg;
  }

  @override
  _CardMemoryState createState() => _CardMemoryState();

  @override
  Future changeStatusCard(bool b) {
    this.isClose = b;
    return new Future.delayed(const Duration(seconds: 1));
  }


}

class _CardMemoryState extends State<CardMemory> {
  @override
  Widget build(BuildContext context) {
    if (widget.isClose) {
      return GestureDetector(
        child: getCloseCard(context),
        onTap: () async {
          if (widget.game.allowSwapCards()) {
            await changeStatusCard(false);
            widget.game.cardClicked();
          }
        },
      );
    } else {
      return getOpenCard(context);
    }
  }

  void _listener() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    widget.addListener(_listener);
  }


  Future changeStatusCard(bool isClose) async {
    setState(() {
      widget.isClose = isClose;
    });
    return new Future.delayed(const Duration(seconds: 2));
  }

  Widget getOpenCard(BuildContext context) {
    if (widget.isEnglishCard) {
      return new Card(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.english,
              style: TextStyle(
                fontFamily: "Carter-e"
              ),
            ),
          ),
      );
    } else {
      return
//        new Container(
//        height: 100,
//        width: 70,
//        child:
        Card(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.hebrew,
              style: TextStyle(
                fontFamily: "Dorian-h"
              ),
            ),
          ),
        //),
      );
    }
  }

  Widget getCloseCard(BuildContext context) {
//    int howMuchCards = this.widget.game.pairs.length * 2;
    return
//      new Container(
//      height: 100,
//      width: 70,
//      child:
      Card(
        color: Colors.amberAccent,
//      ),
    );
  }
}
