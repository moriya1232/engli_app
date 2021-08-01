import 'dart:async';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/WinnerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Turn extends StatefulWidget {
  final QuartetsGame game;
  Player playerChosenToAsk;
  Subject subjectToAsk;
  CardQuartets cardToAsk;

  Turn(QuartetsGame g) : this.game = g {
    this.playerChosenToAsk = g.listTurn[(g.turn + 1) % g.listTurn.length];
    List<String> subjects = g.getMyPlayer().getSubjects();
    if (subjects.isNotEmpty) {
      this.subjectToAsk = g.getSubjectByString(subjects[0]);
      this.cardToAsk = this.subjectToAsk.getCards()[0];
    } else {
      this.subjectToAsk = null;
      this.cardToAsk = null;
    }
  }

  @override
  _turnState createState() => _turnState();
}

class _turnState extends State<Turn> {
  bool chosenPlayerAndCategoryToAsk = false;
  bool _firstClick1;
  bool _firstClick2;

  @override
  Widget build(BuildContext context) {
      // if my turn and i have no cards, I need to take card from the deck and my turn pass over.
     if (this.widget.game.turn != null &&
        widget.game.getPlayerNeedTurn() is Me &&
        this.widget.game.getPlayerNeedTurn().cards.length == 0) {
      this.widget.game.deck.giveCardToPlayer(
          this.widget.game.getPlayerNeedTurn(), this.widget.game);
      this.widget.game.doneTurn();
    } else {
      this._firstClick1 = true;
      this._firstClick2 = true;
      return getAprropriateAsk();
    }
  }

  Widget getAprropriateAsk() {
    //subject to ask not in my cards.
    if (!this.widget.game.getMyPlayer().getSubjects().contains(this.widget.subjectToAsk.nameSubject)) {
      this.widget.subjectToAsk = this.widget.game.getSubjectsOfPlayer(this.widget.game.getMyPlayer())[0];
    }
    if (!this.chosenPlayerAndCategoryToAsk) {
      List<String> names = widget.game.getNamesPlayers();
      names.remove(widget.game.getMyPlayer().name);
      if (widget.subjectToAsk != null && !widget.game.checkIfGameDone() && this._firstClick1) {

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onPressed: () async {
                    this._firstClick1 = false;
                    askClicked();
                  },
                  child: Text(
                    '!שאל',
                    style: TextStyle(
                        fontFamily: 'Comix-h',
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'בחר קטגוריה',
                      style: TextStyle(
                        fontFamily: 'Abraham-h',
                      ),
                    ),
                    DropdownButton<String>(
                      value: widget.subjectToAsk.nameSubject,
                      style: TextStyle(color: Colors.black87),
                      underline: Container(
                        height: 2,
                        width: 10,
                        color: Colors.amberAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          Subject sub = widget.game.getSubjectByString(newValue);
                          if (this.widget.game.getMyPlayer().getSubjects().contains(sub.nameSubject)) {
                            widget.subjectToAsk = sub;
                            widget.cardToAsk = widget.subjectToAsk
                                .getCards()[0];
                          } else {
                            print("bug");
                            widget.subjectToAsk = widget.game.getSubjectByString(this.widget.game.getMyPlayer().getSubjects()[0]);
                            widget.cardToAsk = widget.subjectToAsk.getCards()[0];
                          }
                        });
                      },
                      items: widget.game
                          .getMyPlayer()
                          .getSubjects()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Courgette-e'),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'בחר יריב',
                      style: TextStyle(
                        fontFamily: 'Abraham-h',
                      ),
                    ),
                    DropdownButton<String>(
                      value: widget.playerChosenToAsk.name,
                      //hint: new Text("בחר כמות משתתפים"),
                      style: TextStyle(color: Colors.black87),
                      underline: Container(
                        height: 2,
                        width: 10,
                        color: Colors.amberAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          widget.playerChosenToAsk =
                              widget.game.getPlayerByName(newValue);
                        });
                      },
                      items:
                          names.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:
                                TextStyle(fontSize: 15, fontFamily: 'Miri-h'),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
            ),
          ],
        );
      } else {
        return new Container();
      }
    } else {
      if (widget.subjectToAsk != null && this._firstClick2) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onPressed: () async {
                    if(!this._firstClick2) {return;}
                    setState(() {
                      print("firstClick2: ");
                      print(_firstClick2);
                      this._firstClick2 = false;
                    });
                    if (await doTurn()) {
                      print("more turn!");
                      widget.game
                          .removeAllSeriesDone(widget.game.getPlayerNeedTurn());
                      await updateMoreTurn();
                      if (widget.game.getPlayerNeedTurn().cards.length == 0) {
                        doneTurn();
                      }
                    } else {
                      doneTurn();
                    }
                  },
                  child: Text(
                    '!שאל',
                    style: TextStyle(
                        fontFamily: 'Comix-h',
                        color: Colors.black87,
                        fontSize: 15),
                  ),
                )),
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'בחר קלף',
                    style: TextStyle(
                      fontFamily: 'Abraham-h',
                    ),
                  ),
                  DropdownButton<String>(
                    value: widget.cardToAsk.english,
                    style: TextStyle(color: Colors.black87),
                    underline: Container(
                      height: 2,
                      width: 10,
                      color: Colors.amberAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        widget.cardToAsk =
                            widget.subjectToAsk.getCardByString(newValue);
                      });
                    },
                    items: widget.subjectToAsk
                        .getNamesCards()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'Courgette-e'),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
          ],
        );
      } else {
        return new Container();
      }
    }
  }

  Future updateMoreTurn() {
    setState(() {
      chosenPlayerAndCategoryToAsk = false;
      //widget.game.updateObservers();
    });
    return Future.delayed(Duration(seconds: 1));
  }

  void doneTurn() {
    if (widget.game.doneTurn()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WinnerScreen(widget.game)),
      );
    }
  }

  Future<bool> doTurn() async {
    print(
        "ask ${widget.playerChosenToAsk.name}, on subject ${widget.subjectToAsk.nameSubject}, on card: ${widget.cardToAsk.english}");
    if (widget.game.askPlayerSpecCard(
            widget.playerChosenToAsk, widget.subjectToAsk, widget.cardToAsk) !=
        null) {
      await widget.game
          .takeCardFromPlayer(widget.cardToAsk, widget.playerChosenToAsk);
      return Future.delayed(Duration(seconds: 2)).then((value) => true);
    } else {
      await widget.game.takeCardFromDeck();
      return Future.delayed(Duration(seconds: 2)).then((value) => false);
    }
  }

  String getValueForCardString() {
//    if (widget.cardToAsk == null) {
//      return widget.subjectToAsk.getNamesCards()[0];
//    } else {
    return widget.cardToAsk.english;
    //}
  }

  askClicked() async {
    if (widget.playerChosenToAsk
        .getSubjects()
        .contains(widget.subjectToAsk.nameSubject)) {
      setState(() {
        this.chosenPlayerAndCategoryToAsk = true;
      });
    } else {
      await widget.game.takeCardFromDeck();

      doneTurn();
      print(
          "${widget.playerChosenToAsk} don't have subject: ${widget.subjectToAsk}, so player dont ask about spec card.");
    }
  }
}
