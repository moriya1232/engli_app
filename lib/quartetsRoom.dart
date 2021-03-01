import 'package:engli_app/cards/CardQuartets.dart';
import 'package:flutter/material.dart';
import 'players/player.dart';

// לטפל במקרה של יותר מדי קלפים, שיעמדו אחד על השני

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
    players.add(me);
    players.add(player1);
    players.add(player2);
    players.add(player3);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('משחק רביעיות'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Center(
        child: Container(
          child: Column(children: [
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
            //TODO: הקלפים נמתחים בהתאם לליסט וויו. לבדוק
            Expanded(
              child: Row(),
            ),
            Container(
              height: 200,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: me.cards,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Player createPlayer(bool isMe) {
    List<CardQuartets> cards = [
      CardQuartets("table", "שולחן", Image(image: AssetImage('images/table.jpg'),), "furniture", "chair", "cupboard",
          "bed", isMe),
      CardQuartets("english", "עברית02", null, "subject", "word1", "word2",
          "word3", isMe),
      CardQuartets("english", "עברית03", null, "subject", "word1", "word2",
          "word3", isMe),
      CardQuartets("english", "עברית04", null, "subject", "word1", "word2",
          "word3", isMe),
    ];
    if (isMe) {
      cards.add(CardQuartets("english", "עברית1", null, "subject", "word1",
          "word2", "word3", isMe));
      cards.add(CardQuartets("english", "עברית2", null, "subject", "word1",
          "word2", "word3", isMe));
      cards.add(CardQuartets("english", "עברית3", null, "subject", "word1",
          "word2", "word3", isMe));
      cards.add(CardQuartets("english", "עברית4", null, "subject", "word1",
          "word2", "word3", isMe));
      cards.add(CardQuartets("english", "עברית5", null, "subject", "word1",
          "word2", "word3", isMe));
      cards.add(CardQuartets("english", "hebrew", null, "subject", "word1",
          "word2", "word3", isMe));

      return Me(cards);
    } else {
      return Other(cards);
    }
  }
}
