import 'dart:async';
import 'dart:math';
import 'package:engli_app/players/player.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/material.dart';
import 'Loading.dart';
import 'QuartetsGame/Constants.dart';
import 'QuartetsRoom.dart';

class OpenRoom extends StatefulWidget {
  String dropdownValue = '2';
  List<CheckBoxTile> series;
  String gameId;
  bool visibleSumPlayers = false;
  final _sc = StreamController<List<String>>.broadcast();

  OpenRoom(String gameId) {
    this.series = [];
    this.gameId = gameId;
  }

  @override
  _openRoomState createState() => _openRoomState();
}

class _openRoomState extends State<OpenRoom> {
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
            Expanded(
              child: Container(
                height: 500,
                child: _buildSubjectsList(widget._sc),
              ),
            ),
            SizedBox(height: 10,),
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
                    fontFamily: 'Comix-h',
                    color: Colors.black87,
                    fontSize: 20),
              ),
            ),
            if (this.widget.visibleSumPlayers) selectNumPlayersWidget(),
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
                        '!התחל משחק',
                        style: TextStyle(
                            fontFamily: 'Comix-h',
                            color: Colors.black87,
                            fontSize: 40),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  void againstComputerClicked() {
    setState(() {
      this.widget.visibleSumPlayers = true;
    });
  }

  void startGameClicked(bool isAgainstComputer) {
    // for (CheckBoxTile cb in this.widget.series) {
    //   print(cb.title + ": " + cb.value.toString());
    // }
    loadAllMarkedSeries();
    if (!isAgainstComputer) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Loading(widget.gameId, true)),
      );
    } else {
      List<Player> players = [];
      // create players.
      for (int i = 0; i < int.parse(this.widget.dropdownValue); i++) {
        if (i == 0) {
          createPlayer(players, true, quartetsMe);
          continue;
        }
        var random = Random();
        createPlayer(players, false,
            optionalsNames[random.nextInt(optionalsNames.length)]);
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuartetsRoom(
                    players,
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
          DropdownButton<String>(
            value: widget.dropdownValue,
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
              setState(() {
                widget.dropdownValue = newValue;
                startGameClicked(true);
              });
            },
            items: <String>['2', '3', '4']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 25),
                ),
              );
            }).toList(),
          ),
          Container(
            //width: 200,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                ':כמות משתתפים',
                style:
                TextStyle(fontSize: 25, fontFamily: 'Abraham-h'),
              ),
            ),
          ),
        ]);
  }

  Player createPlayer(List<Player> players, bool isMe, String name) {
    Player player;
    if (isMe) {
      player = Me([], name, "");
    } else {
      player = ComputerPlayer([], name, "");
    }
    players.add(player);
    return player;
  }

  void getAllSeriesNames() async {
    List<String> l =
        await GameDatabaseService().getSubjectsList("generic_subjects");
    this.widget._sc.add(l);
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

  void loadAllMarkedSeries() async {
    //widget.series
    List<String> list = [];
    for (var k in widget.series) {
      if (k.value != null && k.value != false) {
        list.add(k.title);
      }
    }

//update the subject list in the game file
    await GameDatabaseService().updateSubjectList(widget.gameId, list);
  }
}

class CheckBoxTile extends StatefulWidget {
  final _sc = StreamController<bool>.broadcast();
  String title = "";
  bool value;

  CheckBoxTile(String title) {
    this.title = title;
  }

  @override
  _CheckBoxTileState createState() => _CheckBoxTileState();
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    return _buildCheckBox(widget._sc);
  }

  Widget _buildCheckBox(StreamController sc) {
    return StreamBuilder<bool>(
        stream: sc.stream,
        initialData: false,
        builder: (context, snapshot) {
          return CheckboxListTile(
            title: Text(widget.title),
            value: snapshot.data ?? false,
            onChanged: (bool value) {
              widget.value = value;
              // print("refresh! " + this.widget.title + ": " + value.toString());
              sc.add(value);
            },
          );
        });
  }
}
