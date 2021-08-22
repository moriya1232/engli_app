import 'dart:async';
import 'package:engli_app/MemoryRoom.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cards/Subject.dart';

// ignore: must_be_immutable
class OpenMemoryRoom extends StatefulWidget {
  bool _generic = false;
  final _nameEnemy = TextEditingController();
  List<CheckBoxTile> _series;
  bool _startGameFirstClick = true;

  OpenMemoryRoom() {
    this._series = [];
  }

  @override
  _OpenMemoryRoomState createState() => _OpenMemoryRoomState();
}

class _OpenMemoryRoomState extends State<OpenMemoryRoom> {
  final _error = StreamController<String>.broadcast();
  final _subjectsList = StreamController<List<String>>.broadcast();
  final _textReplaceData = StreamController<String>.broadcast();

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
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getGenericSeriesWidget(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: TextFormField(
                  controller: this.widget._nameEnemy,
                  decoration: InputDecoration(
                    hintText: "שם יריב",
                    hintStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/30,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  inputFormatters: [
                    new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(3),
                child: getError(),
              ),
              Expanded(
//                    height: 220,
                  child: _buildSubjectsList(this._subjectsList)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

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
                            fontSize: MediaQuery.of(context).size.width/17),
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
                            fontSize: MediaQuery.of(context).size.width/15),
                      ),
                    )),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  Widget getGenericSeriesWidget() {
    return StreamBuilder<String>(
        stream: this._textReplaceData.stream,
        initialData: "להחלפה לסריות גנריות",
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                snapshot.data,
                style: TextStyle(fontSize: MediaQuery.of(context).size.width/20, fontFamily: "Comix-h"),
              ),
              RawMaterialButton(
                onPressed: () {
                  clearCheckboxes();
                  this.widget._generic = !this.widget._generic;
                  if (this.widget._generic) {
                    getGenericSeriesNames();
                    this._textReplaceData.add("להחלפה לסריות שלי");
                  } else {
                    getAllSeriesNames();
                    this._textReplaceData.add("להחלפה לסריות גנריות");
                  }
                },
                hoverColor: Colors.black87,
                highlightColor: Colors.lightGreen,
                shape: CircleBorder(),
                fillColor: Colors.white,
                child: Icon(
                  Icons.refresh,
                  size: 20,
                ),
              ),
            ],
          );
        });
  }

  void clearCheckboxes() {
    for (CheckBoxTile cb in this.widget._series) {
      cb.value = false;
    }
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
              fontSize: MediaQuery.of(context).size.width/30,
              color: Colors.red,
            ),
          );
        });
  }

  void startGameClicked(bool isAgainstComputer) async {
    if (this.widget._nameEnemy.text.length == 0) {
      this._error.add("הכנס שם יריב");
      return;
    }
    List<Subject> subjects = await loadAllMarkedSeries();
    if (subjects.length < 1) {
      this._error.add("בחר לפחות סרייה אחת");
      return;
    } else if (subjects.length > 5) {
      this._error.add("בחר עד 5 סריות");
      return;
    }
    if (!this.widget._startGameFirstClick) {return;}
    this.widget._startGameFirstClick = false;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MemoryRoom(
              isAgainstComputer, this.widget._nameEnemy.text, subjects)),
    );
    await Future.delayed(Duration(seconds: 1));
    this.widget._startGameFirstClick = true;
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
    String userId = FirebaseAuth.instance.currentUser.uid;
    List<String> l = await GameDatabaseService().getSubjectsList(userId);
    this._subjectsList.add(l);
  }

  void getGenericSeriesNames() async {
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
          widget._series = l;
          return ListView(
            shrinkWrap: true,
            children: widget._series,
          );
        });
  }

  Future<List<Subject>> loadAllMarkedSeries() async {
    //widget.series
    List<String> list = [];
    for (var k in widget._series) {
      if (k._value != null && k._value != false) {
        list.add(k.title);
      }
    }
    return await createSubjects(list);
  }

  Future<List<Subject>> createSubjects(List<String> strSub) async {
    List<Subject> subjects = [];
    if (this.widget._generic) {
      for (String s in strSub) {
        Subject sub = await GameDatabaseService()
            .createSubjectFromDatabase("generic_subjects", s);
        subjects.add(sub);
      }
    } else {
      for (String s in strSub) {
        String playerId = FirebaseAuth.instance.currentUser.uid;
        Subject sub =
            await GameDatabaseService().createSubjectFromDatabase(playerId, s);
        subjects.add(sub);
      }
    }
    return Future.value(subjects);
  }

  @override
  void dispose() {
    this._error.close();
    this._subjectsList.close();
    this._textReplaceData.close();
    super.dispose();
  }
}

// ignore: must_be_immutable
class CheckBoxTile extends StatefulWidget {
  // ignore: close_sinks
  final _subjectsTile = StreamController<bool>.broadcast();
  final String title;
  bool _value;

  set value(bool value) {
    _value = value;
//    if (value) {
      this._subjectsTile.add(value);
//    }
  }

  bool get value => _value;

  CheckBoxTile(String title) : this.title = title;
  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return _buildCheckBox();
  }

  Widget _buildCheckBox() {
    return StreamBuilder<bool>(
        stream: this.widget._subjectsTile.stream,
        initialData: false,
        builder: (context, snapshot) {
          return CheckboxListTile(
            title: Text(widget.title, style: TextStyle(fontSize: MediaQuery.of(context).size.width/26),),
            value: snapshot.data ?? false,
            onChanged: (bool value) {
              widget._value = value;
              // print("refresh! " + this.widget.title + ": " + value.toString());
              this.widget._subjectsTile.add(value);
            },
          );
        });
  }

  @override
  void dispose() {
    this.widget._subjectsTile.close();
    super.dispose();
  }
}
