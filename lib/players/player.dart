import 'dart:math';
import 'package:engli_app/cards/CardMemory.dart';
import 'package:engli_app/cards/CardQuartets.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/games/Game.dart';
import 'package:engli_app/games/MemoryGame.dart';
import 'package:engli_app/games/QuartetsGame.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import '../cards/CardGame.dart';

abstract class Player {
  List<CardGame> cards;
  final String name;
  int score;
  final String uid;

  Player(List<CardGame> cards, String name, String uid) : this.name = name, this.uid = uid{
    this.cards = cards;
    this.score = 0;
  }

  bool isHaveCards() {
    if (this.cards.length <= 0) {
      return false;
    }
    return true;
  }

  int raiseScore(int howMuch) {
    this.score += howMuch;
    return this.score;
  }

  void addCard(CardGame card) {
    this.cards.add(card);
  }

  bool takeCardFromPlayer(CardGame card, Player player) {
    if (player.cards.contains(card)) {
      print(this.name + " take card from " + player.name);

      this.cards.add(card);
      player.cards.remove(card);

      if (this is Me) {
        card.changeStatusCard(true);
      } else {
        card.changeStatusCard(false);
      }
      return true;
    } else {
      return false;
    }
  }

  List<String> getSubjects() {
    for (CardGame card in this.cards) {
      if (card is CardMemory) {
        throw Exception("no subjects in memory cards.");
      }
    }
    List<String> subjects = [];
    for (CardQuartets card in this.cards) {
      if (!subjects.contains(card.getSubject())) {
        subjects.add(card.getSubject());
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
    int len = cardsThatNotHave.length;
    if (len <= 0) {return null;}
    return cardsThatNotHave[random.nextInt(len)];
  }
}

class Me extends Player {
  Me(List<CardGame> cards, String name, String uid) : super(cards, name, uid);
}

abstract class Other extends Player {
  Other(List<CardGame> cards, String name, String uid)
      : super(cards, name, uid);
}

class ComputerPlayer extends Other {
  double rememberCance = 0.5;

  ComputerPlayer(List<CardGame> cards, String name, String uid)
      : super(cards, name, uid);
  void changeRememberChance(double r) {
    this.rememberCance = r;
  }

  void makeMove(Game game) async {
    if (game is MemoryGame) {
      var random = Random();
      List<CardMemory> cards = game.getCards();
      var n1 = random.nextInt(cards.length);
      var n2 = random.nextInt(cards.length - 1);
      if (n2 >= n1) n2 += 1;
      await game.changeCardState(cards[n1], false); //open card n1
      await game.changeCardState(cards[n2], false); // open card n2
      if (!game.checkOpenCards()) {
        makeMove(game);
      }

//      print("done computer turn");

    } else if (game is QuartetsGame) {
      print("computer player turn");
      var random = Random();
      List<CardQuartets> cards =
          game.getPlayerNeedTurn().cards.cast<CardQuartets>();
      // no cards! so take card from the deck.
      if (cards.length == 0) {
        await game.takeCardFromDeck();
        // update tokens parameters.
      await GameDatabaseService()
          .updateTake(game, game.listTurn.indexOf(this), -1, "", -1, true);
        if (await game.doneTurn()) {
          return;
        }
        return;
      }
      //random subject.
      Subject randSub =
          game.getSubjectByString(cards[random.nextInt(cards.length)].getSubject());

      //random player
      List<Player> playersWithCards = game.getPlayersWithCardsWithoutMe(this);
      if (playersWithCards.length == 0) {
//        print("no one to ask :(");
        game.takeCardFromDeck();
        if (await game.doneTurn()) {
          return;
        }
        return;
      }
      int randNumPlayer = random.nextInt(playersWithCards.length);
      Player randPlayer = playersWithCards[randNumPlayer];

      //random card.
      CardQuartets randCard = getCardThatNotHave(randSub);
      print("random player: ${randPlayer.name}");
      print("random subject: ${randSub.nameSubject}");
      print("random card: ${randCard.english}");

      //ask by chooses. if succeed take card, play again!
      if (await game.askByComputer(randPlayer, randSub, randCard)) {
        print("computer player success take card. more turn!");
        game.removeAllSeriesDone(this);
        if (game.checkIfGameDone()) {
          return;
        }
        makeMove(game);
      } else {
        if (await game.doneTurn()) {
          return;
        }
        print("done computer turn");
      }
    }
  }
}

class VirtualPlayer extends Other {
  VirtualPlayer(List<CardGame> cards, String name, String uid)
      : super(cards, name, uid);
}
