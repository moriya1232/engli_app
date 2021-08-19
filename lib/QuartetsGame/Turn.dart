import 'dart:async';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Turn extends StatefulWidget {
  final QuartetsGame game;
  Player playerChosenToAsk;
  Subject subjectToAsk;
  CardQuartets cardToAsk;
  // ignore: close_sinks
  final _changeState = StreamController<int>.broadcast();

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

  void initScState() {
    this._changeState.add(1);
  }

  @override
  _TurnState createState() => _TurnState();
}

class _TurnState extends State<Turn> {

  final _scPlayerChosen = StreamController<Player>.broadcast();
  final _scSubjectChosen = StreamController<Subject>.broadcast();
  final _scCardChosen = StreamController<CardQuartets>.broadcast();
  bool chosenPlayerAndCategoryToAsk = false;
//  bool _firstClick1;
//  bool _firstClick2;

  @override
  Widget build(BuildContext context) {
//    // if my turn and i have no cards, I need to take card from the deck and my turn pass over.
//    if (this.widget.game.turn != null &&
//        widget.game.getPlayerNeedTurn() is Me &&
//        this.widget.game.getPlayerNeedTurn().cards.length == 0) {
//      this.widget.game.takeCardFromDeck();
//      GameDatabaseService().updateTake(this.widget.game, widget.game.listTurn.indexOf(widget.game.getPlayerNeedTurn()), -1, "", -1, true);
////      this.widget.game.deck.giveCardToPlayer(
////          this.widget.game.getPlayerNeedTurn(), this.widget.game);
//      this.widget.game.doneTurn();
//      return new Container();
//    } else {
//      this._firstClick1 = true;
//      this._firstClick2 = true;
//    getAppropriateAsk();
    return _buildChangeState();
//    }
  }

  @override
  void dispose() {
    this._scCardChosen.close();
    this._scPlayerChosen.close();
    this._scSubjectChosen.close();
    this.widget._changeState.close();
    super.dispose();
  }

  // returns
  // 1- ask subject
  // 2- ask spec card
  Widget _buildChangeState() {

    return StreamBuilder<int>(
        stream: this.widget.game.turnController.stream,
        initialData: this.widget.game.turn,
        builder: (context, snapshot) {
          if (this.widget.game.isFinished) {
            return Container();
          }
          if (snapshot.data != null) {
            int isMe=0;
            Player p = this.widget.game.listTurn[snapshot.data];
            Player needMove = this.widget.game.getPlayerNeedTurn();
            if ( p == needMove) {
              isMe = 1;
            }
            return StreamBuilder<int>(
        stream: this.widget._changeState.stream,
        initialData: isMe,
        builder: (context, snapshot) {
          if (this.widget.game.turn != null &&
              widget.game.getPlayerNeedTurn() is Me &&
              this.widget.game.getPlayerNeedTurn().cards.length == 0) {
            this.widget.game.takeCardFromDeck();
            GameDatabaseService().updateTake(this.widget.game, widget.game.listTurn.indexOf(widget.game.getPlayerNeedTurn()), -1, "", -1, true);
            this.widget.game.doneTurn();
            return new Container();
          }

          else if (snapshot.data == 1) {
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
//                        this._firstClick1 = false;
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
                        getDropDownSubject(),
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
                        getDropDownPlayer(),
                      ]),
                ),
              ],
            );
          }
          else if (snapshot.data == 2) {
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
                      this.widget._changeState.add(0);
                        //await Future.delayed(new Duration(milliseconds: 500));
                        if (await doTurn()) {
                          print("more turn!");
                          widget.game
                              .removeAllSeriesDone(widget.game.getPlayerNeedTurn());
                          await updateMoreTurn();
                          if (widget.game.getPlayerNeedTurn().cards.length == 0) {
                            this.widget.game.doneTurn();
                            return;
                          }
                        } else {
                          this.widget.game.doneTurn();
                          return;
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
                      getDropDownCard(),
                    ]),
              ],
            );
          } else {
            return new Container();
          }
        });}
        else {
        return new Container();
        }
        });
  }

  Widget getDropDownSubject (){
    return StreamBuilder<int>(
        stream: this.widget.game.turnController.stream,
        initialData: this.widget.game.turn,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            bool isMe = false;
            Player p = this.widget.game.listTurn[snapshot.data];
            Player needMove = this.widget.game.getPlayerNeedTurn();
            if ( p == needMove) {
              isMe = true;
            }
            Subject sub;
            if (isMe) {
              sub = widget.game.getSubjectByString(p.getSubjects()[0]);
            }
    return StreamBuilder<Subject>(
      stream: this._scSubjectChosen.stream,
      initialData: sub,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          this.widget.subjectToAsk = snapshot.data;
          String sub = snapshot.data.nameSubject;

          return DropdownButton<String>(
            value: sub,
            style: TextStyle(color: Colors.black87),
            underline: Container(
              height: 2,
              width: 10,
              color: Colors.amberAccent,
            ),
            onChanged: (String newValue) {
              Subject sub =
              widget.game.getSubjectByString(newValue);

              if (this
                  .widget
                  .game
                  .getMyPlayer()
                  .getSubjects()
                  .contains(sub.nameSubject)) {
                widget.subjectToAsk = sub;
                widget.cardToAsk =
                widget.subjectToAsk.getCards()[0];
                this._scSubjectChosen.add(this.widget.subjectToAsk);
                this._scCardChosen.add(this.widget.cardToAsk);
              }
//              else {
//                widget.subjectToAsk = widget.game
//                    .getSubjectByString(this
//                    .widget
//                    .game
//                    .getMyPlayer()
//                    .getSubjects()[0]);
//                widget.cardToAsk =
//                widget.subjectToAsk.getCards()[0];
//                this._scSubjectChosen.add(this.widget.subjectToAsk);
//                this._scCardChosen.add(this.widget.cardToAsk);
//                throw Exception("choose subject that no in my cards.");
//              }
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
          );
        } else {
          return new Container();
        }
      }
    ); } else {
          return new Container();}
        });
  }


  Widget getDropDownCard() {
    return StreamBuilder<int>(
        stream: this.widget.game.turnController.stream,
        initialData: this.widget.game.turn,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            bool isMe = false;
            Player p = this.widget.game.listTurn[snapshot.data];
            Player needMove = this.widget.game.getPlayerNeedTurn();
            if ( p == needMove) {
              isMe = true;
            }
            CardQuartets iniCard;
            if (isMe) {
              iniCard = this.widget.subjectToAsk.getCards()[0];
            }
    return StreamBuilder<CardQuartets>(
        stream: this._scCardChosen.stream,
        initialData: iniCard,
        builder: (context, snapshot) {
      if (snapshot.data != null) {
        String ca = snapshot.data.english;
        return DropdownButton<String>(
          value: ca,
          style: TextStyle(color: Colors.black87),
          underline: Container(
            height: 2,
            width: 10,
            color: Colors.amberAccent,
          ),
          onChanged: (String newValue) {
            widget.cardToAsk =
                widget.subjectToAsk.getCardByString(newValue);
            this._scCardChosen.add(this.widget.cardToAsk);
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
        );
      } else {
        return new Container();
      }
  }); } else {
          return new Container();}
        });
  }

  Widget getDropDownPlayer() {
    List<String> names = widget.game.getNamesPlayers();
    names.remove(widget.game
        .getMyPlayer()
        .name);
    return StreamBuilder<int>(
        stream: this.widget.game.turnController.stream,
        initialData: this.widget.game.turn,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            bool isMe = false;
            Player p = this.widget.game.listTurn[snapshot.data];
            Player needMove = this.widget.game.getPlayerNeedTurn();
            if ( p == needMove) {
              isMe = true;
            }
            Player player;
            if (isMe) {
              player = this.widget.game.listTurn[(snapshot.data + 1) % this.widget.game.listTurn.length];
            }
    return StreamBuilder<Player>(
        stream: this._scPlayerChosen.stream,
        initialData: player,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            String name = snapshot.data.name;
            return DropdownButton<String>(
              value: name,
              style: TextStyle(color: Colors.black87),
              underline: Container(
                height: 2,
                width: 10,
                color: Colors.amberAccent,
              ),
              onChanged: (String newValue) {
                widget.playerChosenToAsk =
                    widget.game.getPlayerByName(newValue);
                this._scPlayerChosen.add(widget.playerChosenToAsk);
              },
              items:
              names.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style:
                    TextStyle(fontSize: 15, fontFamily: 'Courgette-e'),
                  ),
                );
              }).toList(),
            );
          } else {
            return new Container();
          }
  }); }
        else {
          return new Container();
          }});
  }



  void getAppropriateAsk() {
    //subject to ask not in my cards.
    if (!this
        .widget
        .game
        .getMyPlayer()
        .getSubjects()
        .contains(this.widget.subjectToAsk.nameSubject)) {
      this.widget.subjectToAsk = this
          .widget
          .game
          .getSubjectsOfPlayer(this.widget.game.getMyPlayer())[0];
    }

    //ask player and subject.
    if (!this.chosenPlayerAndCategoryToAsk) {

      if (widget.subjectToAsk != null
//      && !widget.game.checkIfGameDone()
//          && this._firstClick1
      ) {
        this.widget._changeState.add(1);
        /////// pass from here!!! 1 ;
      } else {
        this.widget._changeState.add(0);
      }
    } else { // ask spec card.
      if (widget.subjectToAsk != null) {
        this.widget._changeState.add(2);
        // pass from here!!!! 2
      } else {
        this.widget._changeState.add(0);
      }
    }
  }

  Future updateMoreTurn() {

      chosenPlayerAndCategoryToAsk = false;
      //widget.game.updateObservers();
      this.widget._changeState.add(1);
    return Future.delayed(Duration(seconds: 1));
  }

//  void doneTurn() async{
//    if (await widget.game.doneTurn()) {
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) =>
//                WinnerScreen(widget.game, widget.game.gameId)),
//      );
//    }
//  }

  Future<bool> doTurn() async {
    print(
        "ask ${widget.playerChosenToAsk.name}, on subject ${widget.subjectToAsk.nameSubject}, on card: ${widget.cardToAsk.english}");

    // success ask about card.
    if (widget.game.askPlayerSpecCard(
            widget.playerChosenToAsk, widget.subjectToAsk, widget.cardToAsk) !=
        null) {
      await widget.game
          .takeCardFromPlayer(widget.cardToAsk, widget.playerChosenToAsk);
      return Future.delayed(Duration(seconds: 2)).then((value) => true);
    }
    // dont success take card.
    else {
      int take =
          this.widget.game.listTurn.indexOf(widget.game.getPlayerNeedTurn());
      int token = this.widget.game.listTurn.indexOf(widget.playerChosenToAsk);
      String sub = this.widget.subjectToAsk.nameSubject;
      int card = this.widget.game.cardsId[this.widget.cardToAsk];
      //player has this subject but not the card
      if (this
          .widget
          .game
          .askPlayerAboutSubject(widget.playerChosenToAsk, widget.subjectToAsk)) {
        await GameDatabaseService()
            .updateTake(this.widget.game, take, token, sub, card, false);
      }
      //player doesn't have this subject
      else {
        await GameDatabaseService()
            .updateTake(this.widget.game, take, token, sub, null, false);
      }
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
    // success in chosen subject.
    if (widget.playerChosenToAsk
        .getSubjects()
        .contains(widget.subjectToAsk.nameSubject)) {
        this.chosenPlayerAndCategoryToAsk = true;
        this.widget._changeState.add(2);
    }
    // didn't success asking this subject.
    else {
      this.widget._changeState.add(0);
      //update takes parameters in server.
      GameDatabaseService().updateTake(
          widget.game,
          widget.game.listTurn.indexOf(widget.game.getPlayerNeedTurn()),
          widget.game.listTurn.indexOf(widget.playerChosenToAsk),
          widget.subjectToAsk.nameSubject,
          null,
          false);
      await widget.game.takeCardFromDeck();


      print(
          "${widget.playerChosenToAsk} don't have subject: ${widget.subjectToAsk}, so player dont ask about spec card.");
      this.widget.game.doneTurn();
    }
  }
}
