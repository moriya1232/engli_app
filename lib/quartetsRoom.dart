import 'package:engli_app/CardQuartets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'player.dart';

// לטפל במקרה של יותר מדי קלפים, שיעמדו אחד על השני

class QuartetsRoom extends StatefulWidget{
  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {
  List<Player> players = new List<Player>();

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
      body:
      Center (
      child: Container (
    child:Column (
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: player1.cards
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RotatedBox(
                quarterTurns: 1,
                child:Row(
                children: player2.cards,
              ),
              ),
              CardQuartets("english", "hebrew", null, "subject", "word1", "word2", "word3", false),
              RotatedBox(
                quarterTurns: 3,
                child:Row(
                  children: player3.cards,
                ),
              ),
            ],
          ),
        Row(
          children: [
            Center(
              child: Listener(

                  child: Container(
                    height: 140,
                    width: 100,
                    child: null,
                  ),
              ),
            )
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: me.cards,
          ),
        )
        ],
      ),

      ),
      ),

    );
  }


  Player createPlayer(bool isMe) {
    List<CardQuartets> cards= [
      CardQuartets("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardQuartets("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardQuartets("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardQuartets("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardQuartets("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe)];
    if (isMe) {
      return Me(cards);
    } else {
      return Other(cards);
    }
  }
}



