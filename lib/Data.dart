import 'package:flutter/cupertino.dart';

class Data extends ChangeNotifier{
  String name;

  void changeName(String na) {
    this.name = na;
    notifyListeners();
  }

  String getName() {
    return this.name;
  }




}