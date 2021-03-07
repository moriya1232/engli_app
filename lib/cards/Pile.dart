import 'dart:math';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/players/player.dart';

class Pile {
  List<CardQuartets> cards = [];

  Pile(List<Subject> subs) {
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

  void giveCardToPlayer(Player player) {
    if (this.cards.isEmpty) {
      throw Exception("no more cards in the pile");
    } else {
      if (player is Me) {
        player.getCard(cards.removeLast().changeToMine());
      } else {
        player.getCard(cards.removeLast().changeToNotMine());
      }
    }
  }

  void dividePile(List<Player> players) {
    shuffle();
    int maxGameRound = 4;
    for (int round = 0; round < maxGameRound; round++) {
      for (Player player in players) {
        giveCardToPlayer(player);
      }
    }

  }
}