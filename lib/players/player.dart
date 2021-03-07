import '../cards/CardGame.dart';

class Player {
  List<CardGame> cards;

  Player(List<CardGame> cards) {
    this.cards = cards;
  }

  void getCard(CardGame card) {
    this.cards.add(card);
  }
}

class Me extends Player {
  Me(List<CardGame> cards) : super(cards);
}

class Other extends Player {
  Other(List<CardGame> cards) : super(cards);
}
