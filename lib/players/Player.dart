import 'dart:math';
import 'package:engli_app/cards/CardMemory.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/games/Game.dart';
import 'package:engli_app/games/MemoryGame.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import '../cards/CardGame.dart';


abstract class Player {
  List<CardGame> cards;
  String name;
  int score;
//  List<Function> observers;

  Player(List<CardGame> cards, String name) {
    this.cards = cards;
    this.name = name;
    this.score = 0;
//    this.observers = [];
  }

  int raiseScore(int howMuch) {
    this.score+=howMuch;
    print("raise score!");
    return this.score;

//    updateObservers();
  }

//  void addListener(listener) {
//    this.observers.add(listener);
//  }
//
//  void removeListener(listener) {
//    this.observers.remove(listener);
//  }

//  void updateObservers() {
//    for(Function f in this.observers) {
//      f();
//    }
//  }

//  void _listener() {
//    updateObservers();
//  }

  void addCard(CardGame card) {
    this.cards.add(card);
//    card.addListener(_listener);
//    updateObservers();
  }

  bool takeCardFromPlayer(CardGame card, Player player) {
    if (player.cards.contains(card)) {
      this.cards.add(card);
      player.cards.remove(card);
      if (this is Me) {
        print("give card to my player");
        card.changeStatusCard(true);
      } else {
        print("give card to enemy player");
        card.changeStatusCard(false);
      }
      return true;
    } else {
      return false;
    }
  }

  List<String> getSubjects() {
    for (CardGame card in this.cards) {
      if (card is CardMemory){
        throw Exception("no subjects in memory cards.");
      }
    }
    List<String> subjects=[];
    for (CardQuartets card in this.cards){
      if(!subjects.contains(card.subject)) {
        subjects.add(card.subject);
      }
    }
    return subjects;
  }

  CardQuartets getCardThatNotHave(Subject subject) {
    Random random = new Random();
    List<CardQuartets> cardsThatNotHave = [];
    for (CardQuartets card in subject.getCards()) {
      if (!this.cards.contains(card)) {
        cardsThatNotHave.add(card);
      }
    }
    return cardsThatNotHave[random.nextInt(cardsThatNotHave.length)];
  }
}

class Me extends Player {
  Me(List<CardGame> cards, String name) : super(cards, name);
}

abstract class Other extends Player {
  Other(List<CardGame> cards, String name) : super(cards, name);
}

class ComputerPlayer extends Other {
  double rememberCance = 0.5;
  ComputerPlayer(List<CardGame> cards, String name) : super(cards, name);
  void changeRememberChance(double r) {
    this.rememberCance = r;
  }

  void makeMove(Game game) async{
    if (game is MemoryGame) {
      var random = Random();
      List<CardMemory> cards = game.getCards();
      var n1 = random.nextInt(cards.length);
      var n2 = random.nextInt(cards.length-1);
      if (n2 >= n1) n2 += 1;
      await game.changeCardState(cards[n1], false); //open card n1
      await game.changeCardState(cards[n2], false); // open card n2
      if (!game.checkOpenCards()) {
        makeMove(game);
      }

      print("done computer turn");

    }
    else if (game is QuartetsGame) {
      print("computer player turn");

      var random = Random();
      List<CardQuartets> cards = game.getPlayerNeedTurn().cards.cast<CardQuartets>();
      // no cards! so take card from the deck.
      if (cards.length == 0) {
        await game.takeCardFromDeck();
        if (game.doneTurn()) {
          return;
        }
//        updateObservers();
        return;
      }
      //random subject.
      Subject randSub = game.getSubjectByString(cards[random.nextInt(cards.length)].subject);

      //random player
      List<Player> playersWithCards = game.getPlayersWithCardsWithoutMe(this);
      if (playersWithCards.length == 0) {
        print("no one to ask :(");
        game.takeCardFromDeck();
        if (game.doneTurn()) {
          return;
        }
        return;
      }
      int randNumPlayer = random.nextInt(playersWithCards.length);
      Player randPlayer = playersWithCards[randNumPlayer];

      //random card.
      CardQuartets randCard = getCardThatNotHave(randSub);
      print("random subject: ${randSub.name_subject}");
      print("random card: ${randCard.english}");

      //ask by chooses. if succeed take card, play again!
      if (await game.askByComputer(randPlayer, randSub, randCard)){
        game.removeAllSeriesDone(this);
        if(game.checkIfGameDone()) {
          return;
        }
        makeMove(game);
      } else {
        if (game.doneTurn()) {
          return;
        }
        print("done computer turn");
      }
    }
  }


}

class VirtualPlayer extends Other {
  VirtualPlayer(List<CardGame> cards, String name) : super(cards, name);
}
