
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardGame extends StatelessWidget {
  var english = "";
  var hebrew = "";
  var subject = "";
  Image image;
  var word1 = "";
  var word2 = "";
  var word3 = "";
  bool myCard = true;
  bool small = true;


  CardGame(var english, var hebrew, Image image, var subject, var wo1, var wo2,
      var wo3, bool myCard) {
    this.english = english;
    this.hebrew = hebrew;
    this.image = image;
    this.subject = subject;
    this.word1 = wo1;
    this.word2 = wo2;
    this.word3 = wo3;
    this.myCard = myCard;
  }

//
//  CardGameNoImage(var english, var hebrew, var subject) {
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

  @override
  Widget build(BuildContext context) {
    if (myCard) {
      return getOpenCard(context);
    } else {
      return getCloseCard(context);
    }
  }

  Widget getOpenCard(BuildContext context) {
    if (small) {
      return new Container(
        height: 100,
        width: 70,
        child: Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              small = !small;
              print(small);
            },
            child: Column(
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      fontFamily: "Gan-h",
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    english,
                  ),
                  Text(
                    hebrew,
                  ),
                ]
            ),
          ),
        ),
      );
    } else {
      return new Container(
        height: 200,
        width: 140,
        child: Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              small = !small;
              print(small);
            },
            child: Column(
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      fontFamily: "Gan-h",
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    english,
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  Text(
                    hebrew,
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                ]
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