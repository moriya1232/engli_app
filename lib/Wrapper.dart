import 'package:engli_app/ChooseEnemy.dart';
import 'package:engli_app/ChooseGame.dart';
import 'package:engli_app/GetInRoom.dart';
import 'package:engli_app/HomePage.dart';
import 'package:engli_app/OpenRoom.dart';
import 'package:engli_app/QuartetsRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'QuartetsInstructions.dart';
import 'MemoryInstructions.dart';

import 'Loading.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return FirstScreen();
    } else {
      return ChooseGame();
    }

//    return GetInRoom();

//  return MemoryInstructions();
  }
}
