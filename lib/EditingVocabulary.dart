import 'dart:async';
import 'package:engli_app/ChooseGame.dart';
import 'package:engli_app/srevices/gameDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
TODO: dont possible put "," in names cards and subject.
 */

// ignore: must_be_immutable
class EditingVocabulary extends StatefulWidget {
  List<String> series;

  @override
  _EditingVocabularyState createState() => _EditingVocabularyState();
}

class _EditingVocabularyState extends State<EditingVocabulary> {
  _EditingVocabularyState();

  // TODO: need to be stream from the server
  final _seriesController = StreamController<List<String>>.broadcast();
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
    //TODO: insert here the series from database
    this.widget.series = [
      "Pets",
      "Family",
      "Body",
      "Furnitures",
      "Animals",
      "Colors",
      "Food",
      "Cars",
      "Musical Instruments"
    ];
    this._seriesController.add(this.widget.series);
  }

  @override
  Widget build(BuildContext context) {
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
//                SingleChildScrollView(
//                  child: Column(children:
//                  <Widget>[
//                    SizedBox(
//                      height: 20,
//                    ),
////                      Text(
////                        'הכנסת סרייה חדשה',
////                        style: TextStyle(
////                          fontFamily: 'Abraham-h',
////                          fontSize: 30,
////                        ),
////                      ),
////                      Padding(
////                        padding: EdgeInsets.symmetric(horizontal: 40),
////                        child: Row(
////                          crossAxisAlignment: CrossAxisAlignment.center,
////                          mainAxisAlignment: MainAxisAlignment.center,
////                          children: [
////                            Expanded(
////                              child: new Container(
////                                padding: EdgeInsets.symmetric(horizontal: 20),
////                                child: TextFormField(
////                                  textAlign: TextAlign.center,
////                                  //controller: nameController,
////                                ),
////                              ),
////                            ),
////                            Text(
////                              ':שם סרייה',
////                              style: TextStyle(
////                                fontFamily: 'Abraham-h',
////                                fontSize: 15,
////                              ),
////                            )
////                          ],
////                        ),
////                      ),
////                      SizedBox(
////                        height: 20,
////                      ),
////                      SizedBox(
////                        height: 50,
////                        child: Row(
////                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                            crossAxisAlignment: CrossAxisAlignment.stretch,
////                            mainAxisSize: MainAxisSize.max,
////                            children: [
////                              Text(
////                                'תמונה',
////                                style: TextStyle(
////                                  fontFamily: 'Abraham-h',
////                                  fontSize: 20,
////                                ),
////                              ),
////                              SizedBox(width: 5),
////                              Text(
////                                'עברית',
////                                style: TextStyle(
////                                  fontFamily: 'Abraham-h',
////                                  fontSize: 20,
////                                ),
////                              ),
////                              SizedBox(width: 5),
////                              Text(
////                                'אנגלית',
////                                style: TextStyle(
////                                  fontFamily: 'Abraham-h',
////                                  fontSize: 20,
////                                ),
////                              ),
////                            ]),
////                      ),
////                      SizedBox(
////                        height: 50,
////                        child: Row(
////                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                            crossAxisAlignment: CrossAxisAlignment.stretch,
////                            mainAxisSize: MainAxisSize.max,
////                            children: [
////                              Expanded(
////                                child: Padding(
////                                  padding: EdgeInsets.symmetric(
////                                      horizontal: 10, vertical: 5),
////                                  child: TextFormField(
////                                    decoration: InputDecoration(
////                                        border: OutlineInputBorder(
////                                      borderRadius:
////                                          BorderRadius.all(Radius.circular(10)),
////                                    )),
////                                    textAlign: TextAlign.center,
////                                  ),
////                                ),
////                              ),
//                    Expanded(
//                      child: Padding(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: 10, vertical: 5),
//                        child: TextFormField(
//                          decoration: InputDecoration(
//                              border: OutlineInputBorder(
//                                borderRadius:
//                                BorderRadius.all(Radius.circular(10)),
//                              )),
//                          textAlign: TextAlign.center,
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child: Padding(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: 10, vertical: 5),
//                        child: TextFormField(
//                          decoration: InputDecoration(
//                              border: OutlineInputBorder(
//                                borderRadius:
//                                BorderRadius.all(Radius.circular(10)),
//                              )),
//                          textAlign: TextAlign.center,
//                        ),
//                      ),
//                    ),
//                  ]),
//                ),
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
                    new FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    LengthLimitingTextInputFormatter(10)
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
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת]")),
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z]")),
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת]")),
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z]")),
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת]")),
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z]")),
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[א-ת]")),
                                LengthLimitingTextInputFormatter(10)
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
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z]")),
                                LengthLimitingTextInputFormatter(10)
                              ],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Text("4"),
                      ]),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    primary: Colors.pink,
                  ),
                  onPressed: () {
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
                )
              ],
            ),
          );
        });
  }

  removeSer(String ser) {
    this.widget.series.remove(ser);
    this._seriesController.add(this.widget.series);
    //TODO: update server - shilo
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
    GameDatabaseService().addSeries(nameSer, firstEng, firstHeb, secondEng,
        secondHeb, thirdEng, thirdHeb, forthEng, forthHeb);
    this.widget.series.add(nameSer);
    this._seriesController.add(this.widget.series);
    //TODO: update server - shilo!
  }
}
