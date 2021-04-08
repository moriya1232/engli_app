import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/winnerRoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Turn extends StatefulWidget {
  QuartetsGame game;
  Player playerChosenToAsk;
  Subject subjectToAsk;
  CardQuartets cardToAsk;

  Turn(QuartetsGame g) {
    this.game = g;
    this.playerChosenToAsk = g.getFirstPlayer();
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

  @override
  Widget build(BuildContext context) {
    return getAprropriateAsk();
  }

  Widget getAprropriateAsk() {
    if (!this.chosenPlayerAndCategoryToAsk) {
      List<String> names = widget.game.getNamesPlayers();
      names.remove(widget.game.getMyPlayer().name);
      if (widget.subjectToAsk != null && !widget.game.checkIfGameDone()) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.center,
              child: ButtonTheme(
                  buttonColor: Colors.pink,
                  child: SizedBox(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        onPressed: () async {
                          if (widget.playerChosenToAsk.getSubjects().contains(widget.subjectToAsk.name_subject)) {
                            setState(() {
                              this.chosenPlayerAndCategoryToAsk = true;
                            });
                          } else{
                            widget.game.takeCardFromDeck();
                            doneTurn();
                            print("${widget.playerChosenToAsk} don't have subject: ${widget.subjectToAsk}, so player dont ask about spec card.");
                          }
                        },
                        child: Text(
                          '!שאל',
                          style: TextStyle(
                              fontFamily: 'Comix-h',
                              color: Colors.black87,
                              fontSize: 15),
                        ),
                      ))),
            ),
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
                      value: widget.subjectToAsk.name_subject,
                      style: TextStyle(color: Colors.black87),
                      underline: Container(
                        height: 2,
                        width: 10,
                        color: Colors.amberAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          widget.subjectToAsk =
                              widget.game.getSubjectByString(newValue);
                          widget.cardToAsk = widget.subjectToAsk.getCards()[0];
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
                      items: names.map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 15, fontFamily: 'Miri-h'),
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
      if (widget.subjectToAsk != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: ButtonTheme(
                  buttonColor: Colors.pink,
                  child: SizedBox(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        onPressed: () async {
                          if (await doTurn()) {
                            print("more turn!");
                            widget.game.removeAllSeriesDone(
                                widget.game.getPlayerNeedTurn());
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
                      ))),
            ),
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
                          style: TextStyle(fontSize: 18,
                              fontFamily: 'Courgette-e'),
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

  Future updateMoreTurn(){
    setState(() {
      chosenPlayerAndCategoryToAsk = false;
      widget.game.updateObservers();
    });
    return Future.delayed(Duration(seconds: 1));
  }

  void doneTurn(){
    if (widget.game.doneTurn()) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WinnerRoom(widget.game)),
      );
    }
  }

  Future<bool> doTurn() async{
    print("ask ${widget.playerChosenToAsk.name}, on subject ${widget.subjectToAsk.name_subject}, on card: ${widget.cardToAsk.english}");
    if (widget.game.askPlayerSpecCard(widget.playerChosenToAsk,
        widget.subjectToAsk, widget.cardToAsk) !=
        null) {
      await widget.game.takeCardFromPlayer(
          widget.cardToAsk, widget.playerChosenToAsk);
      return true;
    } else {
      widget.game.takeCardFromDeck();
      return false;
    }
  }

  String getValueForCardString() {
//    if (widget.cardToAsk == null) {
//      return widget.subjectToAsk.getNamesCards()[0];
//    } else {
    return widget.cardToAsk.english;
    //}
  }
}
