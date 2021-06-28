import 'package:flutter/material.dart';

/*
2. לשנות שיהיה אפשר לכתוב בעברית בחלק של העברית.TODO:
5. כפתור "סיימתי"TODO:
 */

class EditingVocabulaty extends StatefulWidget {
  List<String> series;

  EditingVocabulaty() {
    //TODO: insert here the series from database
    this.series = [
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
  }

  @override
  _EditingVocabulatyState createState() => _EditingVocabulatyState();
}

class _EditingVocabulatyState extends State<EditingVocabulaty> {
  _EditingVocabulatyState();

  final nameSer = TextEditingController();
  final firstEng = TextEditingController();
  final firstHeb = TextEditingController();
  final secondEng = TextEditingController();
  final secondHeb = TextEditingController();
  final thirdEng = TextEditingController();
  final thirdHeb = TextEditingController();
  final forthEng = TextEditingController();
  final forthHeb = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: Text('עריכת אוצר מילים'),
      ),
      body:
        Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    primary: Colors.pink,
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              '${widget.series[index]}',
                              style: TextStyle(fontFamily: 'Comix-h', fontSize: 20),

                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(icon: Icon(Icons.clear), onPressed: (){
                            removeSer(widget.series[index]);
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
              ),
            ),
          ),
        ]),

    );
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
                  onChanged: (value) {

                  },
                  controller: nameSer,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: "הכנס שם סרייה"),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this.firstHeb,
                              decoration: InputDecoration(
                                hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
                              textAlign: TextAlign.center,

                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: firstEng,
                              decoration: InputDecoration(
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
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
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this.secondHeb,
                              decoration: InputDecoration(
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
                              textAlign: TextAlign.center,

                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: secondEng,
                              decoration: InputDecoration(
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
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
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this.thirdHeb,
                              decoration: InputDecoration(
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
                              textAlign: TextAlign.center,

                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: thirdEng,
                              decoration: InputDecoration(
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
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
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: this.forthHeb,
                              decoration: InputDecoration(
                                  hintText: "עברית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
                              textAlign: TextAlign.center,

                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextFormField(
                              controller: forthEng,
                              //TODO: check limits!
//                              maxLines: 1,
//                              maxLength: 10,
                              decoration: InputDecoration(
                                  hintText: "אנגלית",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  )),
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
                    this.forthEng.clear();
                    this.forthHeb.clear();
                    this.thirdHeb.clear();
                    this.thirdEng.clear();
                    this.secondEng.clear();
                    this.secondHeb.clear();
                    this.firstEng.clear();
                    this.firstHeb.clear();
                    this.nameSer.clear();
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
    //TODO: shilo
  }

  addSer() {
    String nameSer = this.nameSer.text;
    String firstHeb = this.firstHeb.text;
    String firstEng = this.firstEng.text;
    String secondHeb = this.secondHeb.text;
    String secondEng = this.secondEng.text;
    String thirdEng = this.thirdEng.text;
    String thirdHeb = this.thirdHeb.text;
    String forthHeb = this.forthHeb.text;
    String forthEng = this.forthEng.text;

    //TODO: shilo!
  }
}
