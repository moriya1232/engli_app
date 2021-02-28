
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CardGame.dart';

class CardMemory extends CardGame {
  @override
  _CardMemoryState createState() => _CardMemoryState();
  bool isEnglishCard;
  bool isClose;

  CardMemory(String english, String hebrew, bool isEnglish)
      : super(english, hebrew) {
    this.isEnglishCard = isEnglish;
    this.isClose = true;
  }
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
          });
        },
      );
    } else{
      return GestureDetector(
        child: getOpenCard(context),
        onTap: () {
          setState(() {
            widget.isClose = true;
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