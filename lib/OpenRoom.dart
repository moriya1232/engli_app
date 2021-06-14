import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engli_app/cards/Subject.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/material.dart';
import 'Loading.dart';

class OpenRoom extends StatefulWidget {
  String dropdownValue = '2';
  Map<String, bool> series;
  final _sc = StreamController<List<String>>.broadcast();

  OpenRoom() {
    List<String> list = [];
    this.series = {};
    //List<String> list = getAllSeriesNames() as List<String>;
    // this.series = Map.fromIterable(list, key: (e) => e, value: (e) => false);
  }

  @override
  _openRoomState createState() => _openRoomState();
}

class _openRoomState extends State<OpenRoom> {
  @override
  Widget build(BuildContext context) {
    getAllSeriesNames();
    //widget.series = Map.fromIterable(list, key: (e) => e, value: (e) => false);
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
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
                  ]),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: SizedBox(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    primary: Colors.pink,
                  ),
                  onPressed: () {
                    startGameClicked();
                  },
                  child: Text(
                    '!התחל משחק',
                    style: TextStyle(
                        fontFamily: 'Comix-h',
                        color: Colors.black87,
                        fontSize: 20),
                  ),
                )),
              ),
            ),
          ]),
    );
  }

  void startGameClicked() {
    List<Subject> series = loadAllMarkedSeries();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Loading(series)),
    );
  }

  void getAllSeriesNames() async {
    List<String> l =
        await GameDatabaseService().getSubjectsList("generic_subjects");
    print(l);
    this.widget._sc.add(l);
  }

  Widget _buildSubjectsList(StreamController sc) {
    return StreamBuilder<List<String>>(
        stream: sc.stream,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container();
          }
          widget.series = Map.fromIterable(snapshot.data,
              key: (e) => e, value: (e) => false);
          return ListView(
            shrinkWrap: true,
            children: widget.series.keys.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: widget.series[key],
                onChanged: (bool value) {
                  setState(() {
                    widget.series[key] = value;
                  });
                },
              );
            }).toList(),
          );
        });
  }

  List<Subject> loadAllMarkedSeries() {
//TODO: load the marked series to the game --SHILO
    List<Subject> list = [];
    return list;
  }
}
