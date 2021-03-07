import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Pile.dart';
import 'package:flutter/material.dart';
import 'players/player.dart';
import 'cards/Subject.dart';
import 'cards/Triple.dart';

// TODO: diffrenet size of screen

class QuartetsRoom extends StatefulWidget {
  int chosenCard = -1;

  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {
  List<Player> players = [];

  @override
  Widget build(BuildContext context) {
    Me me = createPlayer(true);
    Other player1 = createPlayer(false);
    Other player2 = createPlayer(false);
    Other player3 = createPlayer(false);
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
    players.add(me);
    players.add(player1);
    players.add(player2);
    players.add(player3);
    pile.dividePile(this.players);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('משחק רביעיות'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Center(
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: player1.cards),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: Row(
                    children: player2.cards,
                  ),
                ),
                CardQuartets("english", "hebrew", null, "subject", "word1",
                    "word2", "word3", false),
                RotatedBox(
                  quarterTurns: 3,
                  child: Row(
                    children: player3.cards,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(),
            ),
            Container(
              height: 230,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: me.cards,
              ),
            ),
            Container(
              height: 60,
              color: Colors.black12,
              child: Row(),
            ), // TODO: for chat? microphone?
          ]),
        ),
      ),
    );
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
