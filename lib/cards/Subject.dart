

import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Triple.dart';


class Subject {
  String name_subject;
  List<CardQuartets> cards;

  Subject(String name, Triple card1, Triple card2, Triple card3, Triple card4) {
    this.name_subject = name;
    this.cards = [CardQuartets(
    card1.english,
    card1.hebrew,
    card1.image,
    name,
    card2.english,
    card3.english,
    card4.english,
    false),
      CardQuartets(
          card2.english,
          card2.hebrew,
          card2.image,
          name,
          card1.english,
          card3.english,
          card4.english,
          false),
      CardQuartets(
          card3.english,
          card3.hebrew,
          card3.image,
          name,
          card2.english,
          card1.english,
          card4.english,
          false),
      CardQuartets(
          card4.english,
          card4.hebrew,
          card4.image,
          name,
          card2.english,
          card3.english,
          card1.english,
          false),];
  }

  List<CardQuartets> getCards() {
    return this.cards;
  }

  String getSubject() {
    return this.name_subject;
  }

  List<CardQuartets> getRestCards(CardQuartets card) {
    List<CardQuartets> cardsRest = [];
    for (CardQuartets cardQuartets in this.cards) {
      if (!(card == cardQuartets)) {
        cardsRest.add(cardQuartets);
      }
    }
    return cardsRest;
  }

  List<String> getNamesRestCards(CardQuartets card) {
    List<String> names = [];
    for (CardQuartets c in getRestCards(card)){
      names.add(c.english);
    }
    return names;
  }

  List<String> getNamesCards() {
    List<String> names = [];
    for (CardQuartets card in this.cards){
      names.add(card.english);
    }
    return names;
  }

  CardQuartets getCardByString(String val) {
    for (CardQuartets c in this.cards) {
      if (val == c.english) {
        return c;
      }
    }
    return null;
  }
}