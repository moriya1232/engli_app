import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  List<User> usersLogin;

  Loading() {
    this.usersLogin = [];
  }

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final _usersLoginStreamController = StreamController<String>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('מחכה לשחקנים נוספים...'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          getListNameUsers(),
          SizedBox(
            height: 30,
          ),
          getUserLogin(),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget getListNameUsers() {
    return StreamBuilder<String>(
        stream: _usersLoginStreamController.stream,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: this.widget.usersLogin.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  this.widget.usersLogin[index].displayName,
                );
              });
        });
  }

  Widget getUserLogin() {
    return StreamBuilder<String>(
        stream: _usersLoginStreamController.stream,
        builder: (context, snapshot) {
          return Text(
            snapshot.data == null? snapshot.data + " התחבר ": "מחכה להתחברות שחקנים נוספים",
          );
        });
  }

  void addUser(User user) {
    this._usersLoginStreamController.add(user.displayName);
  }
}
