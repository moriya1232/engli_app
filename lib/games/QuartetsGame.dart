
import 'package:engli_app/QuartetsGame/Constants.dart';
import 'package:engli_app/cards/Deck.dart';
import 'package:flutter/material.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/cards/Triple.dart';
import 'package:engli_app/cards/Subject.dart';

class QuartetsGame {
  List<Player> players = [];
  Deck deck;
  int turn;
  //List<Subject> subjects;

  QuartetsGame() {
    for (int i=0; i<playersNames.length+1; i++) {
      if (i==0) {
        createPlayer(true, quartetsMe);
        continue;
      }
      createPlayer(false, playersNames[i-1]);
    }
    Deck deck = createDeck();
    deck.handoutDeck(this.players);
    this.deck = deck;
    this.turn = 0;
  }

  Player getPlayerByName(String name) {
    //TODO: if there are some players?
    for(Player player in this.players) {
      if (name == player.name){
        return player;
      }
    }
    return null;
  }

  List<String> getNamesPlayers(){
    List<String> names = [];
    for(Player player in this.players){
      names.add(player.name);
    }
    return names;
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
    Subject days1 = Subject(
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
    Subject family1 = Subject(
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
    Subject food1 = Subject(
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
    Subject days2 = Subject(
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
    Subject family2 = Subject(
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
    Subject food2 = Subject(
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
    Subject days3 = Subject(
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
    Subject family3 = Subject(
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
    Subject food3 = Subject(
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
    List<Subject> subs = [furnitures, pets, days, family, food,days1, family1, food1,days2, family2, food2,days3, family3, food3];
    Deck deck = new Deck(subs);
    return deck;
  }

  Player createPlayer(bool isMe, String name) {
    Player player;
    if (isMe) {
      player = Me([], name);
    }
    else {
      player = VirtualPlayer([], name);
    }
    this.players.add(player);
    return player;
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

  Subject getSubjectByString(String sub) {
    for (Subject s in this.deck.subjects){
      if (s.name_subject == sub) {
        return s;
      }
    }
    return null;
  }
}