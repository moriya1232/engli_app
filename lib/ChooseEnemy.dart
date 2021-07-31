//import 'package:engli_app/MemoryRoom.dart';
//import 'package:flutter/material.dart';
//
//class ChooseEnemy extends StatefulWidget {
//  @override
//  _ChooseEnemyState createState() => _ChooseEnemyState();
//}
//
//final enemyNameController = TextEditingController();
//
//class _ChooseEnemyState extends State<ChooseEnemy> {
//  bool showTextFieldEnemyName = false;
//
//  @override
//  Widget build(BuildContext context) {
//    double fontSize = 50;
//    double heightButtons = 140;
//    double widthButtons = MediaQuery.of(context).size.width * (4 / 5);
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.lightGreen,
//        title: Text('בחירת יריב'),
//        centerTitle: true,
//      ),
//      body: Center(
//        child: SingleChildScrollView(
//          child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                ButtonTheme(
//                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
//                    buttonColor: Colors.black87,
//                    child: SizedBox(
//                        height: heightButtons,
//                        width: widthButtons,
//                        child: ElevatedButton(
//                          style: ElevatedButton.styleFrom(
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(22.0)),
//                            primary: Colors.amberAccent,
//                          ),
//                          onPressed: () {
//                            playAgainstComputerClicked();
//                          },
//                          child: Text('שחק נגד המחשב',
//                              textAlign: TextAlign.center,
//                              style: TextStyle(
//                                  fontFamily: 'Comix-h',
//                                  color: Colors.black87,
//                                  fontSize: fontSize)),
//                        ))),
//                SizedBox(height: 20),
//                ButtonTheme(
//                    buttonColor: Colors.amberAccent,
//                    child: SizedBox(
//                        height: heightButtons,
//                        width: widthButtons,
//                        child: ElevatedButton(
//                          style: ElevatedButton.styleFrom(
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(22.0)),
//                            primary: Colors.amberAccent,
//                          ),
//                          onPressed: () {
//                            playAgainstOtherPlayerClicked();
//                          },
//                          child: Text(
//                            'שחק נגד יריב אחר',
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                fontFamily: 'Comix-h',
//                                color: Colors.black87,
//                                fontSize: 50),
//                          ),
//                        ))),
//                showTextFieldEnemyName ? getInputEnemyNameWidget() : SizedBox(),
//              ]),
//        ),
//      ),
//    );
//  }
//
//  Widget getInputEnemyNameWidget() {
//    return Column(children: [
//      Padding(padding: EdgeInsets.all(20), child: TextField(
//        textAlign: TextAlign.center,
//        decoration: InputDecoration(
//                          border: OutlineInputBorder(
//                            borderRadius: const BorderRadius.all(const Radius.circular(20))
//                          ),
//                        hintText: "הכנס שם יריב",
//        ),
//        controller: enemyNameController,
//      ),),
//      SizedBox(height: 10),
//      ButtonTheme(
//          buttonColor: Colors.amberAccent,
//          child: SizedBox(
//              height: 40,
//              width: MediaQuery.of(context).size.width / 4,
//              child: ElevatedButton(
//                style: ElevatedButton.styleFrom(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(22.0)),
//                  primary: Colors.pink,
//                ),
//                onPressed: () {
//                  enterEnemyNameClicked();
//                },
//                child: Text(
//                  'אישור',
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                      fontFamily: 'Comix-h',
//                      color: Colors.black87,
//                      fontSize: 20),
//                ),
//              )))
//    ]);
//  }
//
//  void playAgainstComputerClicked() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => MemoryRoom(true, "מחשב")),
//    );
//  }
//
//  void playAgainstOtherPlayerClicked() {
//    setState(() {
//      this.showTextFieldEnemyName = true;
//    });
//  }
//
//  void enterEnemyNameClicked() {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => MemoryRoom(false, enemyNameController.text)),
//    );
//  }
//}
