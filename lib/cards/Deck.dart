import 'dart:math';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/QuartetsGame/Constants.dart';

class Deck {
  List<CardQuartets> cards = [];
  List<Subject> subjects = [];

  Deck(List<Subject> subs) {
    this.subjects = subs;
    // until here is the fake subs.
    for (Subject sub in subs) {
      this.cards.addAll(sub.getCards());
    }
  }

  List<CardQuartets> shuffle() {
    var random = new Random();

    // Go through all elements.
    for (var i = this.cards.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = this.cards[i];
      this.cards[i] = this.cards[n];
      this.cards[n] = temp;
    }
    return this.cards;
  }

  Future giveCardToPlayer(Player player){
    if (this.cards.isEmpty) {
      throw Exception("no more cards in the pile");
    } else {
      if (player is Me) {
        player.addCard(cards.removeLast().changeToMine());
      } else {
        player.addCard(cards.removeLast().changeToNotMine());
      }
    }
    return new Future.delayed(const Duration(seconds: 1));
  }

  void handoutDeck(List<Player> players) {
    shuffle();
    for (int round = 0; round < howMuchCardsToDivide; round++) {
      for (Player player in players) {
        giveCardToPlayer(player);
      }
    }
  }
}
