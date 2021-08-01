import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Position.dart';

// ignore: must_be_immutable
abstract class CardGame extends StatefulWidget {
  final String english;
  final String hebrew;
  List<Function> observers;
  Position position;

  CardGame(String english, String hebrew) : this.english = english, this.hebrew = hebrew{
    this.observers = [];
    this.position = Position(null, null, null, null);
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
}
