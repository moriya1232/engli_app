import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import 'CardGame.dart';

// ignore: must_be_immutable
class CardQuartets extends CardGame {
  final String _subject;
  final Image _image;
  final String _word1;
  final String _word2;
  final String _word3;
  bool _myCard = true;

  CardQuartets(String english, String hebrew, Image image, String subject,
      String wo1, String wo2, String wo3, bool myCard)
      : this._image = image,
        this._subject = subject,
        this._word1 = wo1,
        this._word2 = wo2,
        this._word3 = wo3,
        super(english, hebrew) {
    this._myCard = myCard;
  }

  @override
  _CardQuartetsState createState() => _CardQuartetsState();

  CardQuartets changeToMine() {
    this._myCard = true;
    return this;
  }

  CardQuartets changeToNotMine() {
    this._myCard = false;
    return this;
  }

  getEnglish() {
    return english;
  }

  getHebrew() {
    return hebrew;
  }

  getSubject() {
    return _subject;
  }

  @override
  Future changeStatusCard(bool b) {
    this._myCard = b;
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
    if (widget._myCard) {
      return getOpenCard(context);
    } else {
      return getCloseCard(context);
    }
  }

  Widget getOpenCard(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 4;
//    double fontSizeWords = height / 13;
    double width = 130;
    return new Container(
      height: height,
      width: width,
      child: Card(
        shape: new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black87, width: 1.0),
            borderRadius: BorderRadius.circular(4.0)),
        borderOnForeground: true,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            //subject
            Container(
              height: height / 6,
              decoration: new BoxDecoration(
                  color: Colors.tealAccent,
                  border: Border.all(color: Colors.white70)),
              child: FittedBox(
                child: Center(
                    child: Text(
                  widget._subject,
                  style: TextStyle(
                    fontFamily: "AkayaK-e",
//                  fontSize: 25,
                  ),
                )),
              ),
            ),
            // image
            Center(
                child: Container(
                    width: width, height: height / 4, child: getImage())),

            // my english word
            Container(
              height: height / 8,
              child: FittedBox(
                child: Center(
                  child: Text(
                    widget.english,
                    style: TextStyle(
                        fontFamily: "Carter-e",
//                      fontSize: fontSizeWords,
                        color: Colors.lightGreen),
                  ),
                ),
              ),
            ),

            // word 1
            Container(
              height: height / 8,
              child: FittedBox(
                child: Center(
                  child: Text(
                    widget._word1,
                    style: TextStyle(
                      fontFamily: "Carter-e",
//                      fontSize: fontSizeWords,
                    ),
                  ),
                ),
              ),
            ),

            // word 2
            Container(
              height: height / 8,
              child: FittedBox(
                child: Center(
                  child: Text(
                    widget._word2,
                    style: TextStyle(
                      fontFamily: "Carter-e",
//                    fontSize: fontSizeWords,
                    ),
                  ),
                ),
              ),
            ),

            // word 3
            Container(
              height: height / 8,
              child: FittedBox(
                child: Center(
                  child: Text(
                    widget._word3,
                    style: TextStyle(
                      fontFamily: "Carter-e",
//                    fontSize: fontSizeWords,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
//        ),
    );
  }

  Future changeStatusCard(bool isMyCard) async {
    setState(() {
      widget._myCard = isMyCard;
    });
    return new Future.delayed(const Duration(seconds: 2));
  }

  Widget getCloseCard(BuildContext context) {
    return new Container(
      height: heightCloseCard,
      width: widthCloseCard,
      child: Card(
        color: Colors.amberAccent,
//        child: Text(
//          this.widget._subject + " " + this.widget.english,
//        ),
      ),
    );
  }

  Widget getImage() {
    if (widget._image != null) {
      return widget._image;
    } else {
      return new Container();
    }
  }
}
