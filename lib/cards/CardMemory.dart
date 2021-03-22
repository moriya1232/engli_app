import 'dart:core';
import 'package:engli_app/MemoryGame/MemoryGame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../MemoryRoom.dart';
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
}

class _CardMemoryState extends State<CardMemory> {
  @override
  Widget build(BuildContext context) {
    if (widget.isClose) {
      return GestureDetector(
        child: getCloseCard(context),
        onTap: () {
          setState(() {
            widget.isClose = false;
            widget.game.cardClicked();
          });
        },
      );
    } else {
      return GestureDetector(
        child: getOpenCard(context),
        onTap: () {
          setState(() {
            widget.isClose = true;
            widget.game.cardClicked();
          });
        },
      );
    }
  }

  Widget getOpenCard(BuildContext context) {
    if (widget.isEnglishCard) {
      return new Container(
        height: 100,
        width: 70,
        child: Card(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.english,
              style: TextStyle(
                fontFamily: "Carter-e"
              ),
            ),
          ),
        ),
      );
    } else {
      return new Container(
        height: 100,
        width: 70,
        child: Card(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.hebrew,
              style: TextStyle(
                fontFamily: "Dorian-h"
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget getCloseCard(BuildContext context) {
    return new Container(
      height: 100,
      width: 70,
      child: Card(
        color: Colors.amberAccent,
      ),
    );
  }
}
