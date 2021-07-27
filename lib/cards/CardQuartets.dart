import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'CardGame.dart';

class CardQuartets extends CardGame {
  var english = "";
  var hebrew = "";
  String subject;
  Image image;
  var word1 = "";
  var word2 = "";
  var word3 = "";
  bool myCard = true;

  CardQuartets(var english, var hebrew, Image image, String subject, var wo1,
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

  CardQuartets changeToMine() {
    this.myCard = true;
    return this;
  }

  CardQuartets changeToNotMine() {
    this.myCard = false;
    return this;
  }
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

  @override
  Future changeStatusCard(bool b) {
    this.myCard = b;
    return new Future.delayed(const Duration(seconds: 1));
  }
}

class _CardQuartetsState extends State<CardQuartets>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.myCard) {
      return getOpenCard(context);
    } else {
      return getCloseCard(context);
    }
  }

//  double smallHeight = 100;
//  double smallWidth = 140;
//  double bigHeight = 200;
//  double bigWidth = 140;

  Widget getOpenCard(BuildContext context) {
//    double height=smallHeight;
//    double width = smallWidth;
//    if (!widget.small) {
//      height=bigHeight;
//      width = bigWidth;
//    }
    double height = MediaQuery.of(context).size.height / 4;
    double fontSizeWords = height / 13;
    double width = 130;
    //TODO: animations.
//    return PositionedTransition(
//      rect: RelativeRectTween(
//        begin:
//        RelativeRect.fromSize(
//            const Rect.fromLTWH(0, 0, width, height), biggest),
//        end:
//        RelativeRect.fromSize(
//            Rect.fromLTWH(biggest.width - bigLogo,
//                biggest.height - bigLogo, bigLogo, bigLogo),
//            biggest),
//      ).animate(CurvedAnimation(
//        parent: _animationController,
//        curve: Curves.elasticInOut,
//      )),
    return new Container(
      height: height,
      width: width,
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black87, width: 1.0),
            borderRadius: BorderRadius.circular(4.0)),
        borderOnForeground: true,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            decoration: new BoxDecoration(
                color: Colors.tealAccent,
                border: Border.all(color: Colors.white70)),
            child: Center(
                child: Text(
              widget.subject,
              style: TextStyle(
                fontFamily: "AkayaK-e",
                fontSize: 25,
              ),
            )),
          ),
          Center(
              child: Container(
                  width: width, height: height / 4, child: widget.image)),
          Center(
            child: Text(
              widget.english,
              style: TextStyle(
                  fontFamily: "Carter-e",
                  fontSize: fontSizeWords,
                  color: Colors.lightGreen),
            ),
          ),
          Center(
            child: Text(
              widget.word1,
              style: TextStyle(
                fontFamily: "Carter-e",
                fontSize: fontSizeWords,
              ),
            ),
          ),
          Center(
            child: Text(
              widget.word2,
              style: TextStyle(
                fontFamily: "Carter-e",
                fontSize: fontSizeWords,
              ),
            ),
          ),
          Center(
            child: Text(
              widget.word3,
              style: TextStyle(
                fontFamily: "Carter-e",
                fontSize: fontSizeWords,
              ),
            ),
          ),
        ]),
      ),
//        ),
    );
  }

  Color getColor(bool chosen) {
    if (chosen) {
      return Colors.red;
    } else {
      return Colors.white70;
    }
  }

  Future changeStatusCard(bool isMyCard) async {
    setState(() {
      widget.myCard = isMyCard;
    });
    return new Future.delayed(const Duration(seconds: 2));
  }

  Widget getCloseCard(BuildContext context) {
    return new Container(
      height: heightCloseCard,
      width: widthCloseCard,
      child: Card(
        color: Colors.amberAccent,
        //TODO: remove this! that just for debug.
        child: Text(
          this.widget.subject + " " + this.widget.english,
        ),
      ),
    );
  }
}
