import 'dart:async';
import 'dart:math';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Loading.dart';
import 'QuartetsGame/Constants.dart';
import 'QuartetsRoom.dart';
import 'cards/Subject.dart';

// ignore: must_be_immutable
class OpenRoom extends StatefulWidget {
  final String gameId;
  bool _generic = false;
  String _dropdownValue = '2';
  List<CheckBoxTile> _series;

  OpenRoom(String gameId) : this.gameId = gameId {
    this._series = [];
  }

  @override
  _OpenRoomState createState() => _OpenRoomState();
}

class _OpenRoomState extends State<OpenRoom> {
  final _error = StreamController<String>.broadcast();
  final _subjectList = StreamController<List<String>>.broadcast();
  final _showSomePlayers = StreamController<bool>.broadcast();
  final _textReplaceData = StreamController<String>.broadcast();
  final _scDropDownValue = StreamController<String>.broadcast();

  @override
  void dispose() {
    this._scDropDownValue.close();
    this._error.close();
    this._subjectList.close();
    this._showSomePlayers.close();
    this._textReplaceData.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getAllSeriesNames();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('פתיחת חדר'),
        centerTitle: true,
        shadowColor: Colors.black87,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getGenericSeriesWidget(),
            getError(),
            Expanded(
              child: Container(
                height: 500,
                child: _buildSubjectsList(this._subjectList),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                primary: Colors.amberAccent,
              ),
              onPressed: () {
                againstComputerClicked();
              },
              child: Text(
                'שחק מול המחשב',
                style: TextStyle(
                    fontFamily: 'Comix-h', color: Colors.black87, fontSize: 20),
              ),
            ),
            getSomePlayersWidget(),
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
                        primary: Colors.pink,
                        padding: EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        startGameClicked(false);
                      },
                      child: Text(
                        '!התחל משחק ברשת',
                        textAlign: TextAlign.center,
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
                style: TextStyle(fontSize: 20, fontFamily: "Comix-h"),
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

  void againstComputerClicked() {
    this._showSomePlayers.add(true);
  }

  void startGameClicked(bool isAgainstComputer) async {
    List<String> subs = getMarkedSeries();
    if (subs.length < 4) {
      this._error.add("בחר לפחות 4 סריות");
      return;
    }
    GameDatabaseService().updateGeneric(widget.gameId, widget._generic);

//    List<Subject> subjects = await getSubjectsFromStrings(subs);
    await GameDatabaseService().updateSubjectList(widget.gameId, subs);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
    String currName = user.displayName;
    if (!isAgainstComputer) {
      await GameDatabaseService().addPlayer(widget.gameId, currName,
          user.uid); //update the subject list in the game file
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Loading(widget.gameId, true)),
      );
    } else {
//      List<Player> players = [];
      // create players.
      GameDatabaseService().updateAgainstComputer(this.widget.gameId, true);
      for (int i = 0; i < int.parse(this.widget._dropdownValue); i++) {
        if (i == 0) {
          print(this.widget.gameId);
          String id = _auth.currentUser.uid;
          await GameDatabaseService()
              .addPlayer(this.widget.gameId, currName, id);
          continue;
        } else {
          var random = Random();
          await GameDatabaseService().addPlayer(
              this.widget.gameId,
              optionalsNames[random.nextInt(optionalsNames.length)],
              i.toString());
        }
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuartetsRoom(
//                    subjects,
//                    players,
                    this.widget.gameId,
                    true,
                    true,
                  )));
    }
  }

  Widget selectNumPlayersWidget() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                startGameClicked(true);
              },
              child: Text('!שחק',
                  style: TextStyle(
                      fontFamily: 'Comix-h', color: Colors.pink, fontSize: 20)),
            ),
          ),
          getDropDown(),
          Container(
            //width: 200,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                ':כמות משתתפים',
                style: TextStyle(fontSize: 25, fontFamily: 'Comix-h'),
              ),
            ),
          ),
        ]);
  }


  Widget getDropDown() {
    return StreamBuilder<String>(
        stream: this._scDropDownValue.stream,
        initialData: '2',
        builder: (context, snapshot) {
      return DropdownButton<String>(
        value: snapshot.data ?? '2',
        //hint: new Text("בחר כמות משתתפים"),
        icon: Icon(Icons.arrow_downward),
        iconSize: 10,
        elevation: 16,
        style: TextStyle(color: Colors.black87),
        underline: Container(
          height: 2,
          width: 10,
          color: Colors.amberAccent,
        ),
        onChanged: (String newValue) {
          this._scDropDownValue.add(newValue);
          this.widget._dropdownValue = newValue;
        },
        items: <String>['2', '3', '4']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 22),
            ),
          );
        }).toList(),
      );
    });
  }

  void getAllSeriesNames() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    List<String> l = await GameDatabaseService().getSubjectsList(userId);
    this._subjectList.add(l);
  }

  void getGenericSeriesNames() async {
    List<String> l =
        await GameDatabaseService().getSubjectsList("generic_subjects");
    this._subjectList.add(l);
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

  Widget getSomePlayersWidget() {
    return StreamBuilder<bool>(
        stream: this._showSomePlayers.stream,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return selectNumPlayersWidget();
          } else {
            return new Container();
          }
        });
  }

  List<String> getMarkedSeries() {
    //widget.series
    List<String> list = [];
    for (var k in widget._series) {
      if (k.value != null && k.value != false) {
        list.add(k.title);
      }
    }
    return list;
  }

  Future<List<Subject>> getSubjectsFromStrings(List<String> strSub) async {
    List<Subject> subs = [];
    for (String s in strSub) {
      Subject sub = await GameDatabaseService()
          .createSubjectFromDatabase("generic_subjects", s);
      subs.add(sub);
    }
    return Future.value(subs);
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

  void clearCheckboxes() {
    for (CheckBoxTile cb in this.widget._series) {
      cb.value = false;
    }
  }
}

// ignore: must_be_immutable
class CheckBoxTile extends StatefulWidget {
  final _subjectList = StreamController<bool>.broadcast();
  final String title;
  bool _value;

  bool get value => _value;

  set value(bool value) {
    _value = value;
    if (value) {
      this._subjectList.add(value);
    }
  }

  CheckBoxTile(String title) : this.title = title;

  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  @override
  void dispose() {
    this.widget._subjectList.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCheckBox();
  }

  Widget _buildCheckBox() {
    return StreamBuilder<bool>(
        stream: this.widget._subjectList.stream,
        initialData: false,
        builder: (context, snapshot) {
          return CheckboxListTile(
            title: Text(widget.title),
            value: snapshot.data ?? false,
            onChanged: (bool value) {
              widget.value = value;
//               print("refresh! " + this.widget.title + ": " + value.toString());
              this.widget._subjectList.add(value);
            },
          );
        });
  }
}
