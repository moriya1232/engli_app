import 'dart:core';
//import 'dart:io';
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
          changeStatusCard(false);

          //TODO: lock it!
          widget.game.cardClicked();
        },
      );
    } else {
      return GestureDetector(
        child: getOpenCard(context),
        onTap: (){
          changeStatusCard(true);

          //TODO: lock it!
          widget.game.cardClicked();
        },
      );
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


  Future changeStatusCard(bool isClose) {
    //await new Future.delayed(const Duration(seconds: 0));
    setState(() {
      widget.isClose = isClose;
    });
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
