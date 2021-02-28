
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CardGame.dart';

class CardMemory extends CardGame {

  CardMemory(String english, String hebrew) : super(english, hebrew);


  @override
  Widget build(BuildContext context) {
    //TODO
    return new Container(
      height: 100,
      width: 70,
      child: Card(
        color: Colors.amberAccent,
      ),
    );
  }

  Widget getOpenCard(BuildContext context) {


  }

  Widget getCloseCard(BuildContext context) {
    return new Container(
      height: 100,
      width: 70,
      child: Card(
        color: Colors.amberAccent,
      ),
    );
  }
}