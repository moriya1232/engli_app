import 'dart:async';
import 'package:engli_app/MemoryRoom.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cards/Subject.dart';

// ignore: must_be_immutable
class OpenMemoryRoom extends StatefulWidget {
  final _nameEnemy = TextEditingController();
  List<CheckBoxTile> series;

  OpenMemoryRoom() {
    this.series = [];
  }

  @override
  _OpenMemoryRoomState createState() => _OpenMemoryRoomState();
}

class _OpenMemoryRoomState extends State<OpenMemoryRoom> {
  final _error = StreamController<String>.broadcast();
  final _subjectsList = StreamController<List<String>>.broadcast();

  @override
  Widget build(BuildContext context) {
    getAllSeriesNames();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('פתיחת חדר זיכרון'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: TextFormField(
                    controller: this.widget._nameEnemy,
                    decoration: InputDecoration(
                        hintText: "שם יריב",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),),
                    inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(padding: EdgeInsets.all(20),
                child: getError(),),
                Container(
                  height: 250,
                  child: _buildSubjectsList(this._subjectsList),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        SizedBox(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            primary: Colors.amberAccent,
                            padding: EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            startGameClicked(true);
                          },
                          child: Text(
                            'משחק מול המחשב',
                            style: TextStyle(
                                fontFamily: 'Comix-h',
                                color: Colors.black87,
                                fontSize: 30),
                          ),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            primary: Colors.pink,
                            padding: EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            startGameClicked(false);
                          },
                          child: Text(
                            'משחק נגד חבר',
                            style: TextStyle(
                                fontFamily: 'Comix-h',
                                color: Colors.black87,
                                fontSize: 30),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget getError() {
    return StreamBuilder<String>(
        stream: this._error.stream,
        initialData: "",
        builder: (context, snapshot) {
          return Text(
            snapshot.data,
            style: TextStyle(
              fontFamily: 'Trashim-h',
              fontSize: 15,
              color: Colors.red,
            ),
          );
        });
  }

  void startGameClicked(bool isAgainstComputer) async {
    if (this.widget._nameEnemy.text.length == 0 ) {
      this._error.add("הכנס שם יריב");
      return;
    }
    List<Subject> subjects = await loadAllMarkedSeries();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MemoryRoom(isAgainstComputer, this.widget._nameEnemy.text, subjects)),
    );
  }

//  Player createPlayer(List<Player> players, bool isMe, String name) {
//    Player player;
//    if (isMe) {
//      player = Me([], name, "");
//    } else {
//      player = ComputerPlayer([], name, "");
//    }
//    players.add(player);
//    return player;
//  }

  void getAllSeriesNames() async {
    //TODO: change it!
    List<String> l =
        await GameDatabaseService().getSubjectsList("generic_subjects");
    this._subjectsList.add(l);
  }

  Widget _buildSubjectsList(StreamController sc) {
    return StreamBuilder<List<String>>(
        stream: sc.stream,
        initialData: [],
        builder: (context, snapshot) {
          // print("stream come! - subjects from database");
          if (snapshot.data == null) {
            return Container();
          }
          List<CheckBoxTile> l = [];
          for (String s in snapshot.data) {
            l.add(new CheckBoxTile(s));
          }
          widget.series = l;
          return ListView(
            shrinkWrap: true,
            children: widget.series,
          );
        });
  }

  Future<List<Subject>> loadAllMarkedSeries() async {
    //widget.series
    List<String> list = [];
    for (var k in widget.series) {
      if (k.value != null && k.value != false) {
        list.add(k.title);
      }
    }
    return await createSubjects(list);
  }
  
  Future<List<Subject>> createSubjects(List<String> strSub) async{
    List<Subject> subjects = [];
    for (String s in strSub) {
      Subject sub = await GameDatabaseService()
          .createSubjectFromDatabase("generic_subjects", s);
      subjects.add(sub);
    }
    return Future.value(subjects);
  }

  @override
  void dispose() {
    this._error.close();
    this._subjectsList.close();
    super.dispose();
  }
  
}

// ignore: must_be_immutable
class CheckBoxTile extends StatefulWidget {

  final String title;
  bool value;

  CheckBoxTile(String title) : this.title = title;
  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  final _subjectsList = StreamController<bool>.broadcast();
  @override
  Widget build(BuildContext context) {
    return _buildCheckBox();
  }

  Widget _buildCheckBox() {
    return StreamBuilder<bool>(
        stream: this._subjectsList.stream,
        initialData: false,
        builder: (context, snapshot) {
          return CheckboxListTile(
            title: Text(widget.title),
            value: snapshot.data ?? false,
            onChanged: (bool value) {
              widget.value = value;
              // print("refresh! " + this.widget.title + ": " + value.toString());
              this._subjectsList.add(value);
            },
          );
        });
  }

  @override
  void dispose() {
    this._subjectsList.close();
    super.dispose();
  }
}
