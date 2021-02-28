import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CardGame.dart';

class CardQuartets extends CardGame {
  var english = "";
  var hebrew = "";
  var subject = "";
  Image image;
  var word1 = "";
  var word2 = "";
  var word3 = "";
  bool myCard = true;
  bool small = true;

  CardQuartets(var english, var hebrew, Image image, var subject, var wo1,
      var wo2, var wo3, bool myCard)
      : super(english, hebrew) {
    this.image = image;
    this.subject = subject;
    this.word1 = wo1;
    this.word2 = wo2;
    this.word3 = wo3;
    this.myCard = myCard;
  }

  @override
  _CardQuartetsState createState() => _CardQuartetsState();

//
//  CardQuartetsNoImage(var english, var hebrew, var subject) {
//    this.english = english;
//    this.hebrew = hebrew;
//    this.image = null;
//    this.subject = subject;
//  }

  getImage() {
    return image;
  }

  getEnglish() {
    return english;
  }

  getHebrew() {
    return hebrew;
  }

  getSubject() {
    return subject;
  }
}
class _CardQuartetsState extends State<CardQuartets> {

  @override
  Widget build(BuildContext context) {
    if (widget.myCard) {
      return getOpenCard(context);
    } else {
      return getCloseCard(context);
    }
  }

  double smallHeight = 100;
  double smallWidth = 70;
  double bigHeight = 200;
  double bigWidth = 140;

  Widget getOpenCard(BuildContext context) {
    double height=smallHeight;
    double width = smallWidth;
    if (!widget.small) {
      height=bigHeight;
      width = bigWidth;
    }

    return new Container(
      height: height,
      width: width,
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setState(() {
              widget.small = !widget.small;
            });
          },
          child: Column(children: [
            Text(
              widget.subject,
              style: TextStyle(
                fontFamily: "Gan-h",
                fontSize: 15,
              ),
            ),
            Text(
              widget.english,
            ),
            Text(
              widget.hebrew,
            ),
          ]),
        ),
      ),
    );
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

