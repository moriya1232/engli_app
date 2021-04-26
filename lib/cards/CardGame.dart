import 'dart:core';

import 'package:engli_app/players/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class CardGame extends StatefulWidget {
  String english = "";
  String hebrew = "";
  List<Function> observers;

  CardGame(String english, String hebrew) {
    this.english = english;
    this.hebrew = hebrew;
    this.observers = [];
  }

  getEnglish() {
    return english;
  }

  getHebrew() {
    return hebrew;
  }

  void addListener(listener) {
    this.observers.add(listener);
  }

  void removeListener(listener) {
    this.observers.remove(listener);
  }

  void updateObservers() {
    for(Function f in this.observers) {
      f();
    }
  }

  Future changeStatusCard(bool b);


  void passCardAnimation(Player targetPlayer) {
    //TODO
  }
}
