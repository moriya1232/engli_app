import 'package:flutter/material.dart';

class EditingVocabulaty extends StatefulWidget {
  List<String> series;

  EditingVocabulaty() {
    //TODO: insert here the series from database
    this.series = ["Pets", "Family", "Body", "Furnitures", "Animals", "Colors", "Food", "Cars", "Musical Instruments"];
  }
  @override
  _EditingVocabulatyState createState() => _EditingVocabulatyState();
}

class _EditingVocabulatyState extends State<EditingVocabulaty> {
  _EditingVocabulatyState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('עריכת אוצר מילים'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'הכנסת סרייה חדשה',
                      style: TextStyle(
                        fontFamily: 'Abraham-h',
                        fontSize: 30,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: new Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                //controller: nameController,
                              ),
                            ),
                          ),
                          Text(
                            ':שם סרייה',
                            style: TextStyle(
                              fontFamily: 'Abraham-h',
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'תמונה',
                              style: TextStyle(
                                fontFamily: 'Abraham-h',
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'עברית',
                              style: TextStyle(
                                fontFamily: 'Abraham-h',
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'אנגלית',
                              style: TextStyle(
                                fontFamily: 'Abraham-h',
                                fontSize: 20,
                              ),
                            ),
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
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 50,
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
                  ]),
                ),

              ]),
          Expanded(
            child: new ListView.builder(
              shrinkWrap: true,
              itemCount: widget.series.length,
              itemBuilder: (context, index) {
                return SizedBox(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '${widget.series[index]}',
                        style: TextStyle(
                            fontFamily: 'Comix-h', fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image(
                        image: AssetImage('icons/pencil.jpg'),
                        height: 20,
                      )
                    ]),
              );
//                return ListTile(
//                  title: Text('${widget.series[index]}'),

              },
            )
          ),
        ]),
      ),
    );
  }
}
