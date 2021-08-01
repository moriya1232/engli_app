import 'package:engli_app/cards/CardMemory.dart';

class Pair{
  final CardMemory _c1;
  final CardMemory _c2;

  CardMemory get c1 => _c1;
  CardMemory get c2 => _c2;

  Pair(CardMemory c1, CardMemory c2) : this._c1 = c1, this._c2 = c2;

  List<CardMemory> getCards() {
    List<CardMemory> li = [c1,c2];
    return li;
  }
}