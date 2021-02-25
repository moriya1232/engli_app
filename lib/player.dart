import 'package:engli_app/cardGame.dart';

class Player {
  List<CardGame> cards;
  bool isMe;

  Player(List<CardGame> cards, bool isMe) {
    this.cards = cards;
    this.isMe = isMe;
  }
}