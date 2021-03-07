
import 'package:engli_app/cards/Pile.dart';
import 'package:flutter/material.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/cards/Subject.dart';

class QuartetsGame {
  List<Player> players = [];
  Pile pile;
  int turn;

  QuartetsGame() {
    Me me = createPlayer(true);
    Other player1 = createPlayer(false);
    Other player2 = createPlayer(false);
    Other player3 = createPlayer(false);
    Pile pile = createPile();
    players.add(me);
    players.add(player1);
    players.add(player2);
    players.add(player3);
    pile.dividePile(this.players);
    this.pile = pile;
    this.turn = 0;
  }

  void doneTurn() {
    this.turn = (this.turn + 1) % this.players.length;
  }

  Player getPlayerNeedTurn() {
    return this.players.elementAt(this.turn);
  }


  int getNumPlayers() {
    return this.players.length;
  }

  Player getFirstPlayer() {
    return this.players.elementAt(1);
  }

  Player getSecondPlayer() {
    return this.players.elementAt(2);
  }

  Player getThirdPlayer() {
    return this.players.elementAt(3);
  }

  Player getMyPlayer() {
    return this.players.elementAt(0);
  }

  Pile createPile(){
    Subject furnitures = Subject(
        "Furnitures",
        Triple(
            "table",
            "שולחן",
            Image(
              image: AssetImage('images/table.jpg'),
            )),
        Triple(
            "chair",
            "כסא",
            Image(
              image: AssetImage('images/chair.jpg'),
            )),
        Triple(
            "bed",
            "מיטה",
            Image(
              image: AssetImage('images/bed.jpg'),
            )),
        Triple(
            "cupboard",
            "ארון",
            Image(
              image: AssetImage('images/cupboard.jpg'),
            )));
    Subject pets = Subject(
        "Pets",
        Triple(
            "cat",
            "חתול",
            Image(
              image: AssetImage('images/cat.jpg'),
            )),
        Triple(
            "dog",
            "כלב",
            Image(
              image: AssetImage('images/dog.jpg'),
            )),
        Triple(
            "hamster",
            "אוגר",
            Image(
              image: AssetImage('images/hamster.jpg'),
            )),
        Triple(
            "fish",
            "דג",
            Image(
              image: AssetImage('images/cat.jpg'),
            )));
    Subject days = Subject(
        "Days",
        Triple("sunday", "יום ראשון", null),
        Triple("monday", "יום שני", null),
        Triple("saturday", "יום שבת", null),
        Triple("friday", "יום שישי", null));
    Subject family = Subject(
        "Family",
        Triple("father", "אבא", null),
        Triple("mother", "אמא", null),
        Triple("sister", "אחות", null),
        Triple("brother", "אח", null));
    Subject food = Subject(
        "Food",
        Triple("pizza", "פיצה", null),
        Triple("rise", "אורז", null),
        Triple("meat", "בשר", null),
        Triple("soap", "מרק", null));
    List<Subject> subs = [furnitures, pets, days, family, food];
    Pile pile = new Pile(subs);
    return pile;
  }

  Player createPlayer(bool isMe) {
    if (isMe) {
      return Me([]);
    }
    else {
      return Other([]);
    }
//    List<CardQuartets> cards = [
//      CardQuartets(
//          "table",
//          "שולחן",
//          Image(
//            image: AssetImage('images/table.jpg'),
//          ),
//          "Furniture",
//          "chair",
//          "cupboard",
//          "bed",
//          isMe),
//      CardQuartets(
//          "chair",
//          "כסא",
//          Image(
//            image: AssetImage('images/chair.jpg'),
//          ),
//          "Furniture",
//          "table",
//          "cupboard",
//          "bed",
//          isMe),
//      CardQuartets(
//          "bed",
//          "מיטה",
//          Image(
//            image: AssetImage('images/bed.jpg'),
//          ),
//          "Furniture",
//          "chair",
//          "cupboard",
//          "table",
//          isMe),
//      CardQuartets(
//          "cupboard",
//          "ארון",
//          Image(
//            image: AssetImage('images/cupboard.jpg'),
//          ),
//          "Furniture",
//          "chair",
//          "table",
//          "bed",
//          isMe),
//    ];
//    if (isMe) {
//      cards.add(CardQuartets(
//          "cat",
//          "חתול",
//          Image(
//            image: AssetImage('images/cat.jpg'),
//          ),
//          "Pets",
//          "dog",
//          "fish",
//          "hamster",
//          isMe),);
//      cards.add(CardQuartets(
//          "dog",
//          "כלב",
//          Image(
//            image: AssetImage('images/dog.jpg'),
//          ),
//          "Pets",
//          "cat",
//          "fish",
//          "hamster",
//          isMe),);
//      cards.add(CardQuartets(
//          "hamster",
//          "אוגר",
//          Image(
//            image: AssetImage('images/hamster.jpg'),
//          ),
//          "Pets",
//          "dog",
//          "fish",
//          "cat",
//          isMe),);
//      cards.add(CardQuartets(
//          "fish",
//          "דג",
//          Image(
//            image: AssetImage('images/cat.jpg'),
//          ),
//          "Pets",
//          "dog",
//          "cat",
//          "hamster",
//          isMe),);
//
//      return Me(cards);
//    } else {
//      return Other(cards);
//    }
  }


}