import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
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
    this.subjectToAsk = g.getSubjectByString(g.getMyPlayer().getSubjects()[0]);
    this.cardToAsk = this.subjectToAsk.getCards()[0];
  }

  @override
  _turnState createState() => _turnState();
}

class _turnState extends State<Turn> {
  @override
  Widget build(BuildContext context) {
    List<String> names = widget.game.getNamesPlayers();
    names.remove(widget.game.getMyPlayer().name);
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
                onPressed: () {
                  if(widget.game.askPlayerSpecCard(
                      widget.playerChosenToAsk, widget.subjectToAsk, widget.cardToAsk) != null){
                    print("need to take the card!!");
                      //widget.game.askPlayerSpecCard(widget.playerChosenToAsk, widget.subjectToAsk, widget.cardToAsk);
                  } else {
                    widget.game.deck.giveCardToPlayer(widget.game.getPlayerNeedTurn());
                  }
                  widget.game.doneTurn();
                  widget.game.checkComputerPlayerTurn();
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
                      style: TextStyle(fontSize: 18, fontFamily: 'Courgette-e'),
                    ),
                  );
                }).toList(),
              ),
            ]),
        Column(
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
                      style: TextStyle(fontSize: 18, fontFamily: 'Courgette-e'),
                    ),
                  );
                }).toList(),
              ),
            ]),
        Column(
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
                items: names.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 15, fontFamily: 'Miri-h'),
                    ),
                  );
                }).toList(),
              ),
            ]),
      ],
    );
  }

  String getValueForCardString() {
//    if (widget.cardToAsk == null) {
//      return widget.subjectToAsk.getNamesCards()[0];
//    } else {
    return widget.cardToAsk.english;
    //}
  }
}
