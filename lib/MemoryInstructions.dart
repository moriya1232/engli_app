import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemoryInstructions extends StatefulWidget {
  @override
  _MemoryInstructionsState createState() => _MemoryInstructionsState();
}

class _MemoryInstructionsState extends State<MemoryInstructions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('הוראות משחק הזיכרון'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
//          child: Flexible(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                getInstructionsString(),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Comix-h',
                  fontSize: 30,
                ),
              ),
            ),
//          ),
        ),
      ),
    );
  }

  String getInstructionsString() {
    String string = 'בחפיסת הקלפים זוגות של קלפים, כאשר זוג קלפים מורכב מקלף אחד של מילה באנגלית וקלף נוסף של פירוש המילה בעברית.\n\n כל הקלפים מפוזרים במרכז הלוח כאשר פניהם כלפי מטה.\n כל שחקן חושף בתורו קלף ולאחר מכן מנסה למצוא את הקלף התואם לו מתוך יתר הקלפים במשחק, כך שכל המשתתפים רואים את הקלפים שהתגלו.\n אם זוג הקלפים שנהפכו תואמים, השחקן ההופך זוכה ב10 נקודות וזוכה לתור נוסף. \n אם לא, הקלפים נהפכים שוב – שפניהם יהיו כלפי מטה, והתור עובר לשחקן הבא.\n\n המשחק נגמר כאשר כל זוגות הכרטיסים נחשפו והמנצח הוא השחקן אם מספר הנקודות הרב ביותר.\n\n תהנו!';
        return string;
  }
}
