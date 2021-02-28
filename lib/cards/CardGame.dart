import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class CardGame extends StatefulWidget {
  String english = "";
  String hebrew = "";

  CardGame(String english, String hebrew) {
    this.english = english;
    this.hebrew = hebrew;
  }

  getEnglish() {
    return english;
  }

  getHebrew() {
    return hebrew;
  }
}
