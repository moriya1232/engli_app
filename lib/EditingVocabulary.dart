import 'dart:async';
import 'package:engli_app/ChooseGame.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class EditingVocabulary extends StatefulWidget {
  List<String> series = [];

  @override
  _EditingVocabularyState createState() => _EditingVocabularyState();
}

class _EditingVocabularyState extends State<EditingVocabulary> {
  _EditingVocabularyState();

  final _seriesController = StreamController<List<String>>.broadcast();
  final _error = StreamController<String>.broadcast();
  final _nameSer = TextEditingController();
  final _firstEng = TextEditingController();
  final _firstHeb = TextEditingController();
  final _secondEng = TextEditingController();
  final _secondHeb = TextEditingController();
  final _thirdEng = TextEditingController();
  final _thirdHeb = TextEditingController();
  final _forthEng = TextEditingController();
  final _forthHeb = TextEditingController();

  @override
  void dispose() {
    this._error.close();
    this._nameSer.dispose();
    this._firstEng.dispose();
    this._firstHeb.dispose();
    this._secondEng.dispose();
    this._secondHeb.dispose();
    this._thirdEng.dispose();
    this._thirdHeb.dispose();
    this._forthEng.dispose();
    this._forthHeb.dispose();
    this._seriesController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._seriesController.add(this.widget.series);
  }

  @override
  Widget build(BuildContext context) {
    getUserSeriesFromDataBase();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: Text('עריכת אוצר מילים'),
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  primary: Colors.amberAccent,
                ),
                onPressed: () {
                  _showMaterialDialog();
                },
                child: Text(
                  'הכנסת סרייה חדשה',
                  style: TextStyle(
                      fontFamily: 'Comix-h',
                      color: Colors.black87,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
        Text(
          'סריות קיימות',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Abraham-h',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            child: _getListSeries(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              primary: Colors.pink,
              padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseGame(),
                  ));
            },
            child: Text(
              'סיימתי',
              style: TextStyle(
                  fontFamily: 'Comix-h', color: Colors.black87, fontSize: 30),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _getListSeries() {
    return StreamBuilder<List<String>>(
        stream: this._seriesController.stream,
        initialData: this.widget.series,
        builder: (context, snapshot) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          '${snapshot.data[index]}',
                          style: TextStyle(fontFamily: 'Comix-h', fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            removeSer(snapshot.data[index]);
                          })
//                          Image(
//                            image: AssetImage('icons/pencil.jpg'),
//                            height: 20,
//                          )
                    ]),
              );
//                return ListTile(
//                  title: Text('${widget.series[index]}'),
            },
          );
        });
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text(
              "הכנסת סרייה חדשה",
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Abraham-h',
                fontSize: 30,
              ),
            ),
            content: Wrap(
              children: [
                TextField(
                  controller: _nameSer,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: "הכנס שם סרייה"),
                  inputFormatters: [
                    new FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z_' -]")),
                    LengthLimitingTextInputFormatter(12)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this._firstHeb,
                              decoration: InputDecoration(
                                isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת_' -]")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: _firstEng,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z_' -]")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Text("1"),
                      ]),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this._secondHeb,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת_' -]")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: _secondEng,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z_' -]")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Text("2"),
                      ]),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this._thirdHeb,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת_' -]")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: _thirdEng,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z -_']")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Text("3"),
                      ]),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this._forthHeb,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת_' -]")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: _forthEng,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z_' -]")),
                                LengthLimitingTextInputFormatter(12)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Text("4"),
                      ]),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getError(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          primary: Colors.pink,
                        ),
                        onPressed: () {
                          if (this._nameSer.text == "" ||
                              this._nameSer == null) {
                            this._error.add("הכנס שם סרייה");
                            return;
                          } else if (this._firstEng.text.isEmpty ||
                              this._firstHeb.text.isEmpty ||
                              this._secondHeb.text.isEmpty ||
                              this._secondEng.text.isEmpty ||
                              this._thirdHeb.text.isEmpty ||
                              this._thirdEng.text.isEmpty ||
                              this._forthHeb.text.isEmpty ||
                              this._forthEng.text.isEmpty) {
                            this._error.add("הכנס ערכים לכל השדות");
                            return;
                          } else if (!checkInputs()) {
                            this._error.add("הכנס ערכים שונים בכל אחד מהשדות");
                            return;
                          }
                          addSer();
                          this._forthEng.clear();
                          this._forthHeb.clear();
                          this._thirdHeb.clear();
                          this._thirdEng.clear();
                          this._secondEng.clear();
                          this._secondHeb.clear();
                          this._firstEng.clear();
                          this._firstHeb.clear();
                          this._nameSer.clear();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'הכנס סרייה',
                            style: TextStyle(
                                fontFamily: 'Comix-h',
                                color: Colors.black87,
                                fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
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

  void getUserSeriesFromDataBase() async {
    String subjectsId = FirebaseAuth.instance.currentUser.uid;
    this.widget.series = await GameDatabaseService().getSubjectsList(subjectsId);
    if (this.widget.series == null) {
      this.widget.series = [];
    }
    this._seriesController.add(this.widget.series);
  }

  removeSer(String ser) {
    this.widget.series.remove(ser);
    this._seriesController.add(this.widget.series);
    widget.series.remove(ser);
    String playerId = FirebaseAuth.instance.currentUser.uid;
    GameDatabaseService().deleteSubjectFromDataBase(ser, playerId, this.widget.series);
  }

  //return true if its OK, false-otherwise
  bool checkInputs() {
    if (isDiff(this._firstEng, this._secondEng) &&
        isDiff(this._firstEng, this._thirdEng) &&
        isDiff(this._firstEng, this._forthEng) &&
        isDiff(this._thirdEng, this._secondEng) &&
        isDiff(this._forthEng, this._secondEng) &&
        isDiff(this._thirdEng, this._forthEng) &&
        isDiff(this._firstHeb, this._secondHeb) &&
        isDiff(this._firstHeb, this._thirdHeb) &&
        isDiff(this._firstHeb, this._forthHeb) &&
        isDiff(this._thirdHeb, this._secondHeb) &&
        isDiff(this._forthHeb, this._secondHeb) &&
        isDiff(this._thirdHeb, this._forthHeb)) {
      return true;
    }
    return false;
  }

  bool isDiff(TextEditingController first, TextEditingController second) {
    if (first.text != second.text) {
      return true;
    }
    return false;
  }

  addSer() async {
    String nameSer = this._nameSer.text;
    String firstHeb = this._firstHeb.text;
    String firstEng = this._firstEng.text;
    String secondHeb = this._secondHeb.text;
    String secondEng = this._secondEng.text;
    String thirdEng = this._thirdEng.text;
    String thirdHeb = this._thirdHeb.text;
    String forthHeb = this._forthHeb.text;
    String forthEng = this._forthEng.text;
    GameDatabaseService().addSeriesToDataBase(nameSer, firstEng, firstHeb, secondEng,
        secondHeb, thirdEng, thirdHeb, forthEng, forthHeb);
    this.widget.series.add(nameSer);
    this._seriesController.add(this.widget.series);
  }
}
