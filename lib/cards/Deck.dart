import 'dart:math';
import 'package:engli_app/cards/CardGame.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/QuartetsGame/Constants.dart';
import 'package:engli_app/srevices/gameDatabase.dart';

class Deck {
  List<CardQuartets> _cards = [];
  final List<Subject> _subjects;

  Deck(List<Subject> subs) : this._subjects = subs{
    for (Subject sub in subs) {
      this._cards.addAll(List.castFrom<CardGame,CardQuartets>(sub.getCards()));
    }
  }

  List<CardQuartets> getCards() {
    return this._cards;
  }

  List<Subject> getSubjects() {
    return this._subjects;
  }

  bool isEmpty() {
    if (this._cards.length <= 0) {
      return true;
    }
    return false;
  }

  void setCards(List<CardQuartets> list) {
    this._cards = list;
  }

  List<CardQuartets> shuffle() {
    var random = new Random();

    // Go through all elements.
    for (var i = this._cards.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = this._cards[i];
      this._cards[i] = this._cards[n];
      this._cards[n] = temp;
    }
    return this._cards;
  }

  Future giveCardToPlayer(Player player, QuartetsGame game) async {
    if (this._cards.isEmpty) {
      throw Exception("no more cards in the pile");
    } else {
      CardQuartets card = _cards.removeLast();
      if (player is Me) {
        player.addCard(card.changeToMine());
      } else {
        player.addCard(card.changeToNotMine());
      }
      if (game != null) {
        await GameDatabaseService().updateTakeCardFromDeck(game, card, player);
      }
    }
    return new Future.delayed(const Duration(seconds: 1));
  }

  void handoutDeck(List<Player> players) {
    shuffle();
    for (int round = 0; round < howMuchCardsToDivide; round++) {
      for (Player player in players) {
        giveCardToPlayer(player, null);
      }
    }
  }

  void printDeck() {
    print("print the cards in the deck!");
    for (CardQuartets card in this._cards) {
      print(card.getSubject() + ": " + card.english);
    }
    print("done print the cards in the deck");
  }
}
