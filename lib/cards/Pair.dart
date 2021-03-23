import 'package:engli_app/cards/CardMemory.dart';

class Pair{
  CardMemory c1;
  CardMemory c2;

  Pair(CardMemory c1, CardMemory c2) {
    this.c1 = c1;
    this.c2 = c2;
  }

  List<CardMemory> getCards() {
    List<CardMemory> li = [c1,c2];
    return li;
  }
}