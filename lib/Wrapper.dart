import 'package:engli_app/ChooseGame.dart';
import 'package:engli_app/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return FirstScreen();
    } else {
      return ChooseGame();
    }

    //return GetInRoom();
  }
}
