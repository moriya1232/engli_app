
import 'package:engli_app/Constants.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:flutter/material.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/cards/Subject.dart';

class QuartetsGame {
  List<Player> players = [];
  Deck deck;
  int turn;

  QuartetsGame() {
    Me me = createPlayer(true, quartetsMe);
    Other player1 = createPlayer(false, qu1);
    Other player2 = createPlayer(false, qu2);
    Other player3 = createPlayer(false, qu3);
    Deck deck = createDeck();
    players.add(me);
    players.add(player1);
    players.add(player2);
    players.add(player3);
    deck.handoutDeck(this.players);
    this.deck = deck;
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

  Deck createDeck(){
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
              image: AssetImage('images/fish.jpg'),
            )));
    Subject days = Subject(
        "Days",
        Triple("sunday", "יום ראשון", Image(
          image: AssetImage('images/sunday.png'),
        )),
        Triple("monday", "יום שני", Image(
          image: AssetImage('images/monday.png'),
        )),
        Triple("saturday", "יום שבת", Image(
          image: AssetImage('images/saturday.png'),
        )),
        Triple("friday", "יום שישי", Image(
          image: AssetImage('images/friday.png'),
        )));
    Subject family = Subject(
        "Family",
        Triple("father", "אבא", Image(
          image: AssetImage('images/father.png'),
        )),
        Triple("mother", "אמא", Image(
          image: AssetImage('images/mother.jpg'),
        )),
        Triple("sister", "אחות", Image(
          image: AssetImage('images/sister.jpg'),
        )),
        Triple("brother", "אח", Image(
          image: AssetImage('images/brother.jpg'),
        )));
    Subject food = Subject(
        "Food",
        Triple("pizza", "פיצה", Image(
          image: AssetImage('images/pizza.jpg'),
        )),
        Triple("rice", "אורז", Image(
          image: AssetImage('images/rice.jpg'),
        )),
        Triple("meat", "בשר", Image(
          image: AssetImage('images/meat.jpg'),
        )),
        Triple("soup", "מרק", Image(
          image: AssetImage('images/soup.png'),
        )));
    List<Subject> subs = [furnitures, pets, days, family, food];
    Deck deck = new Deck(subs);
    return deck;
  }

  Player createPlayer(bool isMe, String name) {
    if (isMe) {
      return Me([], name);
    }
    else {
      return Other([], name);
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