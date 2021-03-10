import '../cards/CardGame.dart';

class Player {
  List<CardGame> cards;
  String name;
  int score;

  Player(List<CardGame> cards, String name) {
    this.cards = cards;
    this.name = name;
    this.score = 0;
  }

  void getCard(CardGame card) {
    this.cards.add(card);
  }
}

class Me extends Player {
  Me(List<CardGame> cards, String name) : super(cards, name);
}

class Other extends Player {
  Other(List<CardGame> cards, String name) : super(cards, name);
}
