import 'package:engli_app/cardGame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'player.dart';

// לטפל במקרה של יותר מדי קלפים, שיעמדו אחד על השני

class QuartetsRoom extends StatefulWidget{
  @override
  _QuartetsRoomState createState() => _QuartetsRoomState();
}

class _QuartetsRoomState extends State<QuartetsRoom> {
  @override
  Widget build(BuildContext context) {
    var me = createPlayer(true);
    var player1 = createPlayer(false);
    var player2 = createPlayer(false);
    var player3 = createPlayer(false);
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
              CardGame("english", "hebrew", null, "subject", "word1", "word2", "word3", false),
              RotatedBox(
                quarterTurns: 3,
                child:Row(
                  children: player3.cards,
                ),
              ),
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
    List<CardGame> cards= [
      CardGame("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardGame("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardGame("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardGame("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe),
      CardGame("english", "hebrew", null, "subject", "word1", "word2", "word3", isMe)];
    return Player(cards, isMe);
  }
}




